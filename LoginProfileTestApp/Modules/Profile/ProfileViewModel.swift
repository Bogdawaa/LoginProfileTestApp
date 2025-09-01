//
//  ProfileViewModel.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 24.08.2025.
//

import UIKit

final class ProfileViewModel {
    private let profileService: ProfileService
    private let authService: AuthService
        
    var onLogoutSuccess: (() -> Void)?
    var onShowAlert: ((AlertConfig) -> Void)?
    var onProfileLoaded: ((Profile) -> Void)?
    var onLoadingStarted: ((Bool) -> Void)?
    var onShowToast: ((String) -> Void)?
    
    private let deviceModel = UIDevice.current.model
    private let osVersion = UIDevice.current.systemVersion
    
    private var loadProfileTask: Task<Void, Never>?
    
    init(
        profileService: ProfileService,
        authService: AuthService,
    ) {
        self.profileService = profileService
        self.authService = authService
    }
    
    convenience init() {
        let tokenStorage = TokenStorageImpl()
        let sessionManager = SessionManager.shared
        let authService = AuthServiceImpl(
            tokenStorage: tokenStorage,
            sessionManager: sessionManager,
        )
        let profileService = ProfileServiceImpl(
            authService: authService,
            tokenStorage: tokenStorage,
        )
        self.init(profileService: profileService, authService: authService)
    }
    
    func loadProfile() {
        loadProfileTask?.cancel()
        loadProfileTask = Task { await getProfile() }
    }
    
    func cancelProfileLoad() {
        loadProfileTask?.cancel()
        loadProfileTask = nil
    }
    
    func logout() async {
        let result = await authService.logout()
        
        await MainActor.run {
            switch result {
            case .success:
                print("Успешный логаут")
                self.onLogoutSuccess?()
            case .failure(let error):
                handleProfileError(error)
                print("Ошибка логаута: \(error.localizedDescription)")
                
            }
        }
    }
    
    private func getProfile() async {
        guard !Task.isCancelled else { return }
        
        await MainActor.run {
            onLoadingStarted?(true)
        }
        
        guard !Task.isCancelled else {
            await MainActor.run { onLoadingStarted?(false) }
            return
        }
        
        let result = await profileService.fetchProfile()
        
        guard !Task.isCancelled else {
            await MainActor.run { onLoadingStarted?(false) }
            return
        }
        
        await MainActor.run {
            onLoadingStarted?(false)
            switch result {
            case .success(let profile):
                self.onProfileLoaded?(profile)
            case .failure(let error):
                print("Ошибка загрузки профиля: \(error)")
                handleProfileError(error)
            }
        }
    }
    
    @MainActor
    private func handleProfileError(_ error: Error) {
        if let networkError = error as? NetworkError {
           switch networkError {
        // если ошибка реаунтентификации - перейти на экран авторизации
           case .reauthFailed, .noToken:
               let alertConfig = AlertConfig(
                   title: "Ошибка",
                   message: networkError.description,
                   actions: [
                       AlertAction(
                           title: "OK",
                           handler: { [weak self] in
                               Task {
                                   await self?.logout()
                               }
                           }
                       )
                   ]
               )
               self.onShowAlert?(alertConfig)
               
           default:
               let errorMessage = (error as? NetworkError)?.description ?? error.localizedDescription
               let alertConfig = AlertConfig(
                title: "Ошибка",
                message: errorMessage,
                actions: [
                    AlertAction(title: "OK"),
                    AlertAction(
                        title: "Повторить",
                        handler: { [weak self] in
                            Task { [weak self] in
                                await self?.getProfile()
                            }
                        }
                    )
                ]
               )
               self.onShowAlert?(alertConfig)
           }
        }
    }
    
    deinit { cancelProfileLoad() }
}

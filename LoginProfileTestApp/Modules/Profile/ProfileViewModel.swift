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
    var onReauthFailed: (() -> Void)?
    var onLoadingStarted: ((Bool) -> Void)?
    
    private let deviceModel = UIDevice.current.model
    private let osVersion = UIDevice.current.systemVersion
    
    init(
        profileService: ProfileService,
        authService: AuthService
    ) {
        self.profileService = profileService
        self.authService = authService
        
        Task {
            await getProfile()
        }
    }
    
    convenience init() {
        let tokenStorage = TokenStorageImpl()
        let sessionManager = SessionManager.shared
        let authService = AuthServiceImpl(tokenStorage: tokenStorage, sessionManager: sessionManager)
        let profileService = ProfileServiceImpl(
            authService: authService,
            tokenStorage: tokenStorage
        )
        self.init(profileService: profileService, authService: authService)
    }
    
    func getProfile() async {
        await MainActor.run {
            onLoadingStarted?(true)
        }
        
        let result = await profileService.fetchProfile()
        
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
    
    func logout() async {
        let result = await authService.logout()
        
        await MainActor.run {
            switch result {
            case .success:
                print("Успешный логаут")
                self.onLogoutSuccess?()
            case .failure(let error):
                print("Ошибка логаута: \(error.localizedDescription)")
            }
        }
    }
    
    private func handleProfileError(_ error: Error) {
        // если ошибка реаунтентификации - перейти на экран авторизации
        if let networkError = error as? NetworkError,
           case .reauthFailed = networkError {
            let alertConfig = AlertConfig(
                title: "Ошибка",
                message: networkError.description,
                actions: [
                    AlertAction(
                        title: "OK",
                        handler: { [weak self] in
                            self?.onReauthFailed?()
                        }
                    )
                ]
            )
            self.onShowAlert?(alertConfig)
        } else {
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

//
//  AppCoordinator.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 26.08.2025.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
    func showLogin()
    func showProfile()
}

final class AppCoordinator: Coordinator {
    private let authService: AuthService
    private let profileService: ProfileService
    var navigationController: UINavigationController
    
    init(
        authService: AuthService,
        profileService: ProfileService,
        navigationController: UINavigationController
    ) {
        self.authService = authService
        self.profileService = profileService
        self.navigationController = navigationController
    }
    
    convenience init(navigationController: UINavigationController) {
        let tokenStorage = TokenStorageImpl()
        let sessionManager = SessionManager.shared
        let authService = AuthServiceImpl(
            tokenStorage: tokenStorage,
            sessionManager: sessionManager,
            networkMonitor: NetworkMonitor.shared
        )
        let profileService = ProfileServiceImpl(
            authService: authService,
            tokenStorage: tokenStorage,
            networkMonitor: NetworkMonitor.shared
        )
        
        // MARK: - init
        self.init(
            authService: authService,
            profileService: profileService,
            navigationController: navigationController
        )
    }
    
    func start() {
        if authService.isAuthenticated {
            showProfile()
        } else {
            showLogin()
        }
    }
    
    func showLogin() {
        let viewModel = LoginViewModel(authService: authService)
        let vc = LoginViewController(viewModel: viewModel, coordinator: self)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func showProfile() {
        let profileViewModel = ProfileViewModel(profileService: profileService, authService: authService)
        let vc = ProfileViewController(viewModel: profileViewModel, coordinator: self)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    
}

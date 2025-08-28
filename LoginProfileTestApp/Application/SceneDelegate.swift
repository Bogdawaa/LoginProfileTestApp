//
//  SceneDelegate.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 21.08.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var authServce: AuthService = AuthServiceImpl()
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let navigationController: UINavigationController = .init()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let appCoordinator: Coordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator.start()
        
    }
}


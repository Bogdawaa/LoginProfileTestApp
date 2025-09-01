//
//  LoginViewModel.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 21.08.2025.
//

import UIKit

final class LoginViewModel {
    
    private let authService: AuthService
    private let deviceModel = UIDevice.current.model
    private let osVersion = UIDevice.current.systemVersion
    private let os = "iOS"
    private let instanceId = "test123"
    private let locale = "ru"
    private let pushPermission = "authorized"
    private let appVersion = "2.0.1"
    
    private let newtworkService: NetworkService = NetworkServiceImpl()
    private let loginValidator: Validator = LoginValidator()
    private let passwordValidator: Validator = PasswordValidator()
    
    private(set) var login: String = "" {
        didSet { didUpdateInput?() }
    }
    private(set) var password: String = "" {
        didSet { didUpdateInput?() }
    }
    
    private var deviceIp: String? {
        return newtworkService.getLocalIP()
    }
    
    var isValidInput: Bool {
        return loginValidator.validate(login) && passwordValidator.validate(password)
    }
    
    var didUpdateInput: (() -> Void)?
    var onShowAlert: ((AlertConfig) -> Void)?
    var onLoginSuccess: (() -> Void)?
    var onLoadingStarted: ((Bool) -> Void)?
    var onShowToast: ((String) -> Void)?
    
    // MARK: - Init
    init(authService: AuthService) {
        self.authService = authService
    }
    
    // MARK: - Public Methods
    func updateLogin(_ login: String) {
        self.login = login
    }
    
    func updatePassword(_ password: String) {
        self.password = password
    }
    
    func loginUser() async {
        guard let deviceIp = deviceIp else {
            await MainActor.run {
                onShowToast?("Проверьте интернет-соединение")
            }
            return
        }
        
        await MainActor.run {
            onLoadingStarted?(true)
        }
        
        let deviceInfo = DeviceInfo(
            os: os,
            ipAddress: deviceIp,
            instanceId: instanceId,
            deviceModel: deviceModel,
            locale: locale,
            pushPermission: pushPermission,
            osVersion: osVersion,
            appVersion: appVersion
        )
        
        let authModel = AuthRequestDTO(
            login: login,
            password: password,
            deviceInfo: deviceInfo
        )
        
        let result = await authService.login(loginInfo: authModel)
        print("result: \(result)")
        
        await MainActor.run {
            onLoadingStarted?(false)
            switch result {
            case .success:
                print("Logged in successfully")
                self.onLoginSuccess?()
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                
                if let networkError = error as? NetworkError {
                    switch networkError {
                    case .noInternetConnection:
                        onShowToast?("Проверьте интернет-соединение")
                    default:
                        let alertConfig = AlertConfig(
                            title: "Ошибка",
                            message: error.description,
                            actions: [AlertAction(title: "OK")]
                        )
                        self.onShowAlert?(alertConfig)
                    }
                }
            }
        }
    }
}

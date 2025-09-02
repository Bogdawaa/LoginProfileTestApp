//
//  AuthService.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 23.08.2025.
//

import Foundation
import Alamofire

protocol AuthService {
    var isAuthenticated: Bool { get }
    func login(loginInfo: AuthRequestDTO) async -> Result<AuthResponseDTO, NetworkError>
    func authByToken(authByTokenRequest: AuthByTokenRequestDTO) async -> Result<Void, NetworkError>
    func logout() async -> Result<LogoutResponseDTO, NetworkError>
}

final class AuthServiceImpl: AuthService {
    private let tokenStorage: TokenStorage
    private let sessionManager: SessionManager
    
    var isAuthenticated: Bool {
        do {
            return try tokenStorage.getAuthToken() != nil
        } catch {
            print("Failed trying to check token: \(error)")
            return false
        }
    }
    
    init(
        tokenStorage: TokenStorage = TokenStorageImpl(),
        sessionManager: SessionManager = SessionManager.shared,
    ) {
        self.tokenStorage = tokenStorage
        self.sessionManager = sessionManager
    }
    
    func login(loginInfo: AuthRequestDTO) async -> Result<AuthResponseDTO, NetworkError> {
        let request = AF.request(
            MileonairEndpoint.login.fullURL,
            method: .post,
            parameters: loginInfo,
            encoder: JSONParameterEncoder.default,
            headers: [
                "Content-Type": "application/json"
            ]
        )
            .validate()

        let response = await request.serializingDecodable(AuthResponseDTO.self).response
        
        switch response.result {
        case .success(let authResponse):
            print("SUCCESS: \(authResponse)")
            
            if authResponse.responseCode != 0 {
                if authResponse.responseCode == 22 {
                    return .failure(.authfailed)
                }
                let errorMessage = authResponse.responseMessage
                return .failure(.serverError(code: authResponse.responseCode, message: errorMessage))
            }
            
            if let token = authResponse.data?.token {
                do {
                    print("Token received: \(token)")
                    try tokenStorage.saveAuthToken(token)
                } catch {
                    print("Unable to save token: \(error.localizedDescription)")
                    return .failure(.networkError(error))
                }
                
                let authByTokenRequest = AuthByTokenRequestDTO(token: token)
                let authByTokenResult = await authByToken(authByTokenRequest: authByTokenRequest)
                
                switch authByTokenResult {
                case .success:
                    return .success(authResponse)
                case .failure(let error):
                    return .failure(error)
                }
                
            } else {
                return .failure(.noToken)
            }
            
        case .failure(let error):
            print("ERROR: \(error)")
            if let data = response.data, let errorString = String(data: data, encoding: .utf8) {
                print("Response data: \(errorString)")
            }
            return .failure(.noInternetConnection)
        }
    }
    
    func authByToken(authByTokenRequest: AuthByTokenRequestDTO) async -> Result<Void, NetworkError> {
        return await withCheckedContinuation { continuation in
            sessionManager.session.request(
                MileonairEndpoint.authByToken.fullURL,
                method: .post,
                parameters: authByTokenRequest,
                encoder: JSONParameterEncoder.default,
                headers: [
                    "Content-Type": "application/json"
                ]
            )
            .validate()
            .responseDecodable(of: AuthByTokenResponseDTO.self) { response in
                switch response.result {
                case .success(let result):
                    print("AUTH BY TOKEN SUCCESS")
                    
                    guard result.responseCode == 0 else {
                        continuation.resume(returning: .failure(.serverError(
                            code: result.responseCode,
                            message: result.responseMessage)))
                        return
                    }
                    
                    if let url = response.request?.url, let cookies = HTTPCookieStorage.shared.cookies(for: url) {
                        for cookie in cookies {
                            print("Cookie received: \(cookie.name)=\(cookie.value)")
                            if cookie.name == "session_id" || cookie.name == "SESSIONID" {
                                print("Session ID cookie found: \(cookie.value)")
                            }
                        }
                    }
                    
                    continuation.resume(returning: .success(()))
                    
                case .failure(let error):
                    print("AUTH BY TOKEN ERROR: \(error)")
                    if let data = response.data, let errorString = String(data: data, encoding: .utf8) {
                        print("Response data: \(errorString)")
                    }
                    continuation.resume(returning: .failure(.noInternetConnection))
                }
            }
        }
        
    }
    
    func logout() async -> Result<LogoutResponseDTO, NetworkError> {
        let request = sessionManager.session.request(
            MileonairEndpoint.logout.fullURL,
            method: .post
        )
        .validate()
        
        let response = await request.serializingDecodable(LogoutResponseDTO.self).response
        
        switch response.result {
        case .success(let response):
            print("LOGOUT RESPONSE: \(response)")
            
            if response.responseCode != 0 {
                let errorMessage = response.responseMessage
                return .failure(.serverError(code: response.responseCode, message: errorMessage))
            }
            
            do {
                try tokenStorage.removeAuthToken()
                sessionManager.clearCookies()
            } catch {
                print("Failed to remove token or cookies: \(error)")
            }
            
            return .success(response)
            
        case .failure(let error):
            print("LOGOUT ERROR: \(error)")
            
            if let data = response.data, let errorString = String(data: data, encoding: .utf8) {
                print("Response data: \(errorString)")
            }
            return .failure(.noInternetConnection)
        }
    }
}

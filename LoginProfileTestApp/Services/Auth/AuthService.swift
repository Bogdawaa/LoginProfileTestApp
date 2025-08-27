//
//  AuthService.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 23.08.2025.
//

import Foundation
import Alamofire

protocol AuthService {
    func login(loginInfo: AuthRequestDTO) async -> Result<AuthResponseDTO, NetworkError>
    func logout() async -> Result<LogoutResponseDTO, NetworkError>
}

final class AuthServiceImpl: AuthService {
    private let tokenStorage: TokenStorage
    
    init(tokenStorage: TokenStorage = TokenStorageImpl()) {
        self.tokenStorage = tokenStorage
    }
    
    func login(loginInfo: AuthRequestDTO) async -> Result<AuthResponseDTO, NetworkError> {
        let request = AF.request(
            "https://devonservice.mileonair.com/api/v1/login",
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
            } else {
                return .failure(.noToken)
            }
            
            return .success(authResponse)
            
        case .failure(let error):
            print("ERROR: \(error)")
            if let data = response.data, let errorString = String(data: data, encoding: .utf8) {
                print("Response data: \(errorString)")
            }
            return .failure(.networkError(error))
        }
    }
    
    func logout() async -> Result<LogoutResponseDTO, NetworkError> {
        do {
            guard let token = try tokenStorage.getAuthToken() else {
                return .failure(.noToken)
            }
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
                    
            let request = AF.request(
                "https://devonservice.mileonair.com/api/v1/login",
                method: .post,
                headers: headers
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
                } catch {
                    print("Failed to remove token: \(error)")
                }
                return .success(response)
                
            case .failure(let error):
                print("LOGOUT ERROR: \(error)")
                
//                do {
//                    // нужно ли удалять локально при ошибке?
////                    try tokenStorage.removeAuthToken()
////                    print("Token removed localy, but network error")
//                } catch {
//                    print("Failed to remove token: \(error)")
//                }
                
                if let data = response.data, let errorString = String(data: data, encoding: .utf8) {
                    print("Response data: \(errorString)")
                }
                return .failure(.networkError(error))
            }
        } catch {
            print("no token to remove")
            return .failure(.noToken)
        }
    }
}

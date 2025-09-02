//
//  ProfileService.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 24.08.2025.
//

import Foundation
import Alamofire

protocol ProfileService {
    func fetchProfile() async -> Result<Profile, NetworkError>
}

final class ProfileServiceImpl: ProfileService {
    private let session: Session
    private let authService: AuthService
    private let tokenStorage: TokenStorage
    
    init(
        authService: AuthService,
        sessionManager: Session = SessionManager.shared.session,
        tokenStorage: TokenStorage,
    ) {
        self.authService = authService
        self.session = sessionManager
        self.tokenStorage = tokenStorage
    }
    
    func fetchProfile() async -> Result<Profile, NetworkError> {
        if let url = URL(string: "https://devonservice.mileonair.com"),
           let cookies = HTTPCookieStorage.shared.cookies(for: url),
           let sessionCookie = cookies.first(where: { $0.name == "session_id" }) {
            print("Session cookie found: \(sessionCookie.name)=\(sessionCookie.value)")
        } else {
            print("No session cookies found")
            let result = await handleSessionExpired()
            
            switch result {
            case .success(let profile):
                return .success(profile)
            case .failure(let error):
                return .failure(error)
            }
        }
        
        let request = AF.request(
            MileonairEndpoint.profile.fullURL,
            method: .get
        )
        .validate()
       
        let response = await request.serializingDecodable(ProfileResponseDTO.self).response
        switch response.result {
        case .success(let profileResponse):
            if profileResponse.responseCode != 0 {
                if (20...22).contains(profileResponse.responseCode) {
                  return await handleSessionExpired()
                }
                return .failure(.serverError(
                    code: profileResponse.responseCode,
                    message: profileResponse.responseMessage
                ))
            }
            return .success(Profile(from: profileResponse))
            
        case .failure:
            return .failure(.noInternetConnection)
        }
    }
    
    private func handleSessionExpired() async -> Result<Profile, NetworkError> {
        print("session expired, trying reauth")
        
        guard let token = try? tokenStorage.getAuthToken() else {
            return .failure(.noToken)
        }
        
        let tokenRequestDTO = AuthByTokenRequestDTO(token: token)
        let result = await authService.authByToken(authByTokenRequest: tokenRequestDTO)
        
        switch result {
        case .success:
            print("Re-auth success, trying fetch profile again")
            return await fetchProfile()
        case .failure(let error):
            print("Re-authentication failed: \(error)")
            switch error {
            case .noInternetConnection, .networkError:
                return .failure(error)
            case .serverError(let code, let message):
                return .failure(.serverError(code: code, message: message))
            default:
                return .failure(error)
            }
        }
    }
}

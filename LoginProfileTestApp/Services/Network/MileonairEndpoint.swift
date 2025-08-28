//
//  MileonairEndpoint.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 28.08.2025.
//

enum MileonairEndpoint {
    case login
    case logout
    case profile
    case authByToken
    
    var path: String {
        switch self {
        case .login: return "/login"
        case .logout: return "/logout"
        case .profile: return "/profile"
        case .authByToken: return "/authByToken"
        }
    }
    
    var fullURL: String {
        let baseURL = "https://devonservice.mileonair.com/api/v1"
        return baseURL + path
    }
}

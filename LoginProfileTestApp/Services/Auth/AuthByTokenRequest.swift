//
//  AuthByTokenRequest.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 26.08.2025.
//

import Foundation

struct AuthByTokenRequest: Encodable {
    let token: String
}

struct AuthByTokenResponse: Decodable {
    let sessionId: String
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case status
    }
}

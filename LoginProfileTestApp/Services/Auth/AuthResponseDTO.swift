//
//  AuthResponseDTO.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 23.08.2025.
//

import Foundation

struct AuthResponseDTO: Decodable {
    let responseCode: Int
    let responseMessage: String
    let data: AuthDataDTO?
}

struct AuthDataDTO: Decodable {
    let token: String
}

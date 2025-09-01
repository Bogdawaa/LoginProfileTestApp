//
//  AuthByTokenResponse.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 01.09.2025.
//

import Foundation

struct AuthByTokenResponseDTO: Decodable {
    let responseCode: Int
    let responseMessage: String
}

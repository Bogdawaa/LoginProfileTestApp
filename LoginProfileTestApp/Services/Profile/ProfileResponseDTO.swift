//
//  ProfileResponseDTO.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 25.08.2025.
//

import Foundation

struct ProfileResponseDTO: Decodable {
    let responseCode: Int
    let responseMessage: String
    let data: ProfileDataDTO?
}

struct ProfileDataDTO: Decodable {
    let profile: ProfileDTO?
}

struct ProfileDTO: Decodable {
    let email: String
    let firstName: String
    let lastName: String
    let groupName: String
    let groupTag: String
    let isAdmin: Bool
    let languageCode: String
    let login: String
    let points: [ServicePointDTO]?
    let serviceType: [String]
    let terminal: Bool
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case firstName = "first_name"
        case lastName = "last_name"
        case groupName = "group_name"
        case groupTag = "group_tag"
        case isAdmin = "is_admin"
        case languageCode = "language_code"
        case login = "login"
        case points = "points"
        case serviceType = "service_type"
        case terminal = "terminal"
    }
}

struct ServicePointDTO: Decodable {
    let airport: String
    let isClear: Int
    let descriptionShort: String
    let multipleSessionEnable: String?
    let photoPath: [String]
    let pointId: Int
    let pointId1C: String
    let pointName: String
    let products: [ProductDTO]
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case airport = "airport"
        case isClear = "clear"
        case descriptionShort = "description_short"
        case multipleSessionEnable = "multiple_session_enable"
        case photoPath = "photo_path"
        case pointId = "point_id"
        case pointId1C = "point_id_1c"
        case pointName = "point_name"
        case products = "products"
        case type = "type"
    }
}

struct ProductDTO: Decodable {
    let active: Bool
    let locale: String
    let name: String
    let offlinePrice: Int
    let onlinePrice: Int
    let productId: Int
    
    enum CodingKeys: String, CodingKey {
        case active = "active"
        case locale = "locale"
        case name = "name"
        case offlinePrice = "offline_price"
        case onlinePrice = "online_price"
        case productId = "product_id"
    }
}

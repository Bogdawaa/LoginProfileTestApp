//
//  AuthRequestDTO.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 23.08.2025.
//

import Foundation

struct AuthRequestDTO: Encodable {
    let login: String
    let password: String
    let deviceInfo: DeviceInfo
    
    enum CodingKeys: String, CodingKey {
        case login, password
        case deviceInfo = "device_info"
    }
}

struct DeviceInfo: Encodable {
    let os: String
    let ipAddress: String
    let instanceId: String
    let deviceModel: String
    let locale: String
    let pushPermission: String
    let osVersion: String
    let appVersion: String
    
    enum CodingKeys: String, CodingKey {
        case os
        case ipAddress = "ip_address"
        case instanceId = "instance_id"
        case deviceModel = "device_model"
        case locale
        case pushPermission = "push_permission"
        case osVersion = "os_version"
        case appVersion = "app_version"
    }
}

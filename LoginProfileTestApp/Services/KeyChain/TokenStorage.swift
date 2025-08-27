//
//  KeyChainService.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 25.08.2025.
//

import Foundation
import KeychainAccess

protocol TokenStorage {
    func saveAuthToken(_ token: String) throws
    func getAuthToken() throws -> String?
    func removeAuthToken() throws
}

final class TokenStorageImpl: TokenStorage {
    
    private enum Keys: String {
        case authToken = "authToken"
    }
    
    private let keychain: Keychain
    private let serviceName: String
    private let accessGroup: String?
    
    init(
        serviceName: String = Bundle.main.bundleIdentifier ?? "ru.bogdanFartdinov.LoginProfileTestApp",
        accessGroup: String? = nil
    ) {
        self.serviceName = serviceName
        self.accessGroup = accessGroup
        self.keychain = Keychain(service: serviceName, accessGroup: accessGroup)
    }
    
    
    func saveAuthToken(_ token: String) throws {
        try keychain.set(token, key: Keys.authToken.rawValue)
    }
    
    func getAuthToken() throws -> String? {
        return try keychain.getString(Keys.authToken.rawValue)
    }
    
    func removeAuthToken() throws {
        try keychain.remove(Keys.authToken.rawValue)
    }
}

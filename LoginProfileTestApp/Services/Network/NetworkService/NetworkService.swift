//
//  NetworkService.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 26.08.2025.
//

import Foundation
import SwiftIP

protocol NetworkService {
    func getLocalIP() -> String?
    func getPublicIP() -> String?
}

final class NetworkServiceImpl: NetworkService {
    func getLocalIP() -> String? {
        guard let localIP = IP.local() else {
            print("Could not find local IP")
            return nil
        }
        return localIP
    }
    
    func getPublicIP() -> String? {
        return IP.public()
    }
}

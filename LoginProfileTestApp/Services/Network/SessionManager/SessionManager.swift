//
//  SessionManager.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 26.08.2025.
//

import Foundation
import Alamofire

final class SessionManager {
    static let shared = SessionManager()
    
    let session: Session
    
    private init() {
        let configuration = URLSessionConfiguration.af.default
        configuration.httpShouldSetCookies = true
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        self.session = Session(configuration: configuration)
    }
    
    func clearCookies() {
        if let url = URL(string: "https://devonservice.mileonair.com"),
           let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
}

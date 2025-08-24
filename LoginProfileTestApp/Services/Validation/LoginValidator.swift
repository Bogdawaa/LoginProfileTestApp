//
//  EmailValidator.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 23.08.2025.
//

import Foundation

final class LoginValidator: Validator {
    func validate(_ input: String) -> Bool {
        guard input.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
            return false
        }
        return true
    }
}

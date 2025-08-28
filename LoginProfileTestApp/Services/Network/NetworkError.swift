//
//  NetworkError.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 25.08.2025.
//

import Foundation

enum NetworkError: Error {
    case serverError(code: Int, message: String)
    case noToken
    case invalidResponse
    case networkError(Error)
    case logoutFailed
    case tokenExpired
    case noSession
    case reauthFailed
    case authfailed
    case noInternetConnection
    
    var description: String? {
        switch self {
        case .serverError(let code, let message):
            return "Ошибка \(code): \(message)"
        case .noToken:
            return "Токен не получен"
        case .invalidResponse:
            return "Неверный ответ сервера"
        case .networkError(let error):
            return error.localizedDescription
        case .logoutFailed:
            return "Не удалось выйти из системы"
        case .tokenExpired:
            return "Токен просрочен"
        case .noSession:
            return "Сессия не найдена"
        case .reauthFailed:
            return "Ошибка обновления сессии"
        case .authfailed:
            return "Неверный логин или пароль"
        case .noInternetConnection:
            return "Отсутствует интернет-соединение"
        }
    }
}

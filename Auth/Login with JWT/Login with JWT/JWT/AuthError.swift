//
//  AuthError.swift
//  Login with JWT
//
//  Created by Israel Manzo on 5/4/26.
//

import Foundation

/// Auth/session errors that the UI can present to the user.
enum AuthError: LocalizedError {
    case invalidCredentials
    case noRefreshToken
    case tokenExpired
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password."
        case .noRefreshToken:
            return "No refresh token available. Please log in again."
        case .tokenExpired:
            return "Your session has expired. Please log in again."
        case .unauthorized:
            return "Unauthorized. Please log in again."
        }
    }
}


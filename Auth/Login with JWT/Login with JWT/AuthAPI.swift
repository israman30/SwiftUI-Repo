//
//  AuthAPI.swift
//  Login with JWT
//
//  Created by Israel Manzo on 5/3/26.
//

import Foundation

enum AuthError: LocalizedError {
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password."
        }
    }
}

struct AuthAPI {
    static func login(email: String, password: String) async throws -> String {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        try await Task.sleep(nanoseconds: 600_000_000)

        guard !trimmedEmail.isEmpty, !password.isEmpty else {
            throw AuthError.invalidCredentials
        }

        // Replace with your real backend call that returns a JWT.
        return "demo.jwt.token"
    }
}


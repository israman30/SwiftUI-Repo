//
//  AuthAPI.swift
//  Login with JWT
//
//  Created by Israel Manzo on 5/3/26.
//

import Foundation

struct Constants {
    static let endpoint = ""
}

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String?
    let expiresIn: TimeInterval
    let tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken  = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn    = "expires_in"
        case tokenType    = "token_type"
    }
}

enum AuthApi {
    static func login(email: String, password: String) async throws -> JWToken {
        let url = URL(string: Constants.endpoint.appending("/auth/login"))!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode([
            "email":    email,
            "password": password
        ])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch http.statusCode {
        case 200...299:
            let decoded = try JSONDecoder().decode(AuthResponse.self, from: data)
            return JWToken(
                accessToken:  decoded.accessToken,
                refreshToken: decoded.refreshToken,
                expiresIn:    decoded.expiresIn,
                tokenType:    decoded.tokenType,
                issuedAt:     Date()
            )
        case 401:
            throw AuthError.unauthorized
        default:
            throw URLError(.badServerResponse)
        }
    }
    
    static func refresh(refreshToken: String) async throws -> JWToken {
        let url = URL(string: Constants.endpoint.appending("/auth/refresh"))!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["refreshToken": refreshToken])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw AuthError.tokenExpired
        }
        
        let decoded = try JSONDecoder().decode(AuthResponse.self, from: data)
        return JWToken(
            accessToken:  decoded.accessToken,
            refreshToken: decoded.refreshToken,
            expiresIn:    decoded.expiresIn,
            tokenType:    decoded.tokenType,
            issuedAt:     Date()
        )
    }
}

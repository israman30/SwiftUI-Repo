//
//  TokenManager.swift
//  Login with JWT
//
//  Created by Israel Manzo on 5/3/26.
//

import Foundation

private enum TokenKey {
    static let jwt = "jwt_token"
    static let refresh = "refresh_token"
}

final class TokenManager {
    static let shared = TokenManager()
    private init() { }
    
    private let keychain = KeychainManager.shared
    
    func saveToken(_ token: JWToken) throws {
        try keychain.save(token, forKey: TokenKey.jwt)
        // logger.logToken(event: "saved", token: token)
    }
    
    func getToken() throws -> JWToken {
        try keychain.read(JWToken.self, forKey: TokenKey.jwt)
    }
    
    var accessToken: String? {
        try? getToken().accessToken
    }
    
    var bearerHeader: String? {
        try? getToken().bearerToken
    }
    
    var isAuthenticated: Bool {
        guard let token = try? getToken() else { return false }
        return !token.isExpired
    }
    
    var tokenNeedsRefresh: Bool {
        guard let token = try? getToken() else { return false }
        return token.isNearExpired
    }
    
    func refreshTokenIfNeeded() async throws {
        guard tokenNeedsRefresh else { return }
        
        let currentToken = try getToken()
        guard let refreshToken = currentToken.refreshToken else {
            throw AuthError.noRefreshToken
        }
        
        // logger.logToken(event: "refreshing", token: currentToken)
        
        let newToken = try await AuthApi.refresh(refreshToken: refreshToken)
        try saveToken(newToken)
        
        // logger.logToken(event: "refreshed", token: newToken)
    }
    
    func clearToken() throws {
        try keychain.delete(forKey: TokenKey.jwt)
        // logger.log(level: .warning, message: "JWT token cleared — user logged out")
    }
    
    var currentUserId: String? {
        try? getToken().payload?.userId
    }
    
    var currentUserEmail: String? {
        try? getToken().payload?.email
    }
}


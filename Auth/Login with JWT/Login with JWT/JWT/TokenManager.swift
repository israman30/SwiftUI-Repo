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

/// Central place to persist and reason about the current JWT session.
///
/// Responsibilities:
/// - Persist the server-issued `JWToken` securely (Keychain).
/// - Provide computed helpers used by the app (authenticated state, bearer header).
/// - Refresh the token shortly before expiry (when a refresh token is present).
///
/// This keeps token logic out of views and networking call sites.
final class TokenManager {
    static let shared = TokenManager()
    private init() { }
    
    private let keychain = KeychainManager.shared
    
    /// Stores the full token bundle in Keychain.
    func saveToken(_ token: JWToken) throws {
        try keychain.save(token, forKey: TokenKey.jwt)
        // logger.logToken(event: "saved", token: token)
    }
    
    /// Reads the current token from Keychain.
    func getToken() throws -> JWToken {
        try keychain.read(JWToken.self, forKey: TokenKey.jwt)
    }
    
    /// Access token string (if available).
    var accessToken: String? {
        try? getToken().accessToken
    }
    
    /// `"Bearer <access_token>"` header value (if available).
    var bearerHeader: String? {
        try? getToken().bearerToken
    }
    
    /// True when we have a non-expired token stored.
    var isAuthenticated: Bool {
        guard let token = try? getToken() else { return false }
        return !token.isExpired
    }
    
    /// Becomes true a few minutes before expiration so we can refresh proactively.
    var tokenNeedsRefresh: Bool {
        guard let token = try? getToken() else { return false }
        return token.isNearExpired
    }
    
    /// Refreshes the token if it's near expiry.
    ///
    /// Call this before making authorized requests, or opportunistically when the app
    /// becomes active.
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
    
    /// Clears the stored token (logout).
    func clearToken() throws {
        try keychain.delete(forKey: TokenKey.jwt)
        // logger.log(level: .warning, message: "JWT token cleared — user logged out")
    }
    
    /// Convenience accessors for UI display (decoded from JWT payload).
    var currentUserId: String? {
        try? getToken().payload?.userId
    }
    
    var currentUserEmail: String? {
        try? getToken().payload?.email
    }
}


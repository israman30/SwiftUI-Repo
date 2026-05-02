//
//  TokenManager.swift
//  JWT Auth
//
//  Created by Israel Manzo on 5/2/26.
//

import Foundation

struct AuthTokens: Equatable, Sendable {
    var accessToken: String
    var refreshToken: String
}

actor TokenManager {
    static let shared = TokenManager()
    
    private struct DecodedClaims: Sendable {
        var sub: String
        var name: String
        var exp: Int
    }
    
    // Storage:
    // - Demo uses UserDefaults for simplicity.
    // - Production should use Keychain (and consider device migration/biometrics, if needed).
    private let accessTokenKey = "auth.jwt.accessToken"
    private let refreshTokenKey = "auth.jwt.refreshToken"
    
    private var cached: AuthTokens?
    // Single-flight refresh: avoids stampeding the refresh endpoint when multiple requests
    // hit an expired access token at the same time.
    private var inFlightRefresh: Task<AuthTokens, Error>?
    
    init() {
        let access = UserDefaults.standard.string(forKey: accessTokenKey)
        let refresh = UserDefaults.standard.string(forKey: refreshTokenKey)
        if let access, !access.isEmpty, let refresh, !refresh.isEmpty {
            cached = AuthTokens(accessToken: access, refreshToken: refresh)
        }
    }
    
    func currentTokens() -> AuthTokens? {
        cached
    }
    
    func setTokens(_ tokens: AuthTokens?) {
        cached = tokens
        if let tokens {
            UserDefaults.standard.set(tokens.accessToken, forKey: accessTokenKey)
            UserDefaults.standard.set(tokens.refreshToken, forKey: refreshTokenKey)
        } else {
            UserDefaults.standard.removeObject(forKey: accessTokenKey)
            UserDefaults.standard.removeObject(forKey: refreshTokenKey)
        }
    }
    
    func clear() {
        setTokens(nil)
    }
    
    /// Returns a non-expired access token. If the access token is expired (or about to expire),
    /// attempts a refresh using the refresh token.
    func validAccessToken(minValidity: TimeInterval = 60) async throws -> String {
        guard let tokens = cached else { throw APIError.unauthorized }
        
        if let claims = try? await decodeClaims(tokens.accessToken),
           secondsUntilExpiry(exp: claims.exp) > minValidity {
            return tokens.accessToken
        }
        
        let refreshed = try await refreshTokens()
        return refreshed.accessToken
    }
    
    /// Forces a refresh (single-flight) and persists the new tokens.
    func refresh() async throws -> String {
        let refreshed = try await refreshTokens()
        return refreshed.accessToken
    }
    
    private func refreshTokens() async throws -> AuthTokens {
        if let inFlightRefresh {
            return try await inFlightRefresh.value
        }
        guard let tokens = cached else { throw APIError.unauthorized }
        
        // Capture current state for the refresh attempt.
        let access = tokens.accessToken
        let refresh = tokens.refreshToken
        
        let task = Task<AuthTokens, Error> {
            // Demo refresh (replace with a real network call):
            // - Refresh tokens are validated via expiry (in real systems: also verify signature, issuer, etc.).
            // - New access token is minted from refresh claims to tolerate expired access tokens.
            // - Refresh token is rotated to model best-practice refresh flows.
            let refreshClaims = try? await decodeClaims(refresh)
            if let refreshClaims,
               secondsUntilExpiry(exp: refreshClaims.exp) <= 0 {
                throw APIError.unauthorized
            }
            
            let seedClaims: DecodedClaims
            if let refreshClaims {
                seedClaims = refreshClaims
            } else {
                seedClaims = try await decodeClaims(access)
            }
            
            let newAccess = try await makeToken(
                userId: seedClaims.sub,
                name: seedClaims.name,
                issuer: "com.israelmanzo.jwt-auth.mock",
                audience: "jwt-auth-demo",
                expiresIn: 60 * 60
            )
            let newRefresh = try await makeToken(
                userId: seedClaims.sub,
                name: seedClaims.name,
                issuer: "com.israelmanzo.jwt-auth.mock.refresh",
                audience: "jwt-auth-demo-refresh",
                expiresIn: 60 * 60 * 24 * 7
            )
            
            return AuthTokens(accessToken: newAccess, refreshToken: newRefresh)
        }
        
        inFlightRefresh = task
        defer { inFlightRefresh = nil }
        
        let newTokens = try await task.value
        setTokens(newTokens)
        return newTokens
    }
    
    private func secondsUntilExpiry(exp: Int) -> TimeInterval {
        TimeInterval(exp) - Date().timeIntervalSince1970
    }
    
    private func decodeClaims(_ token: String) async throws -> DecodedClaims {
        // The module uses "default isolation = MainActor". Rather than making the whole token
        // pipeline main-thread-bound, we hop only for the decode and then return a Sendable DTO.
        try await MainActor.run(body: {
            let claims = try JWT.decodeClaims(from: token)
            return DecodedClaims(sub: claims.sub, name: claims.name, exp: claims.exp)
        })
    }
    
    private func makeToken(
        userId: String,
        name: String,
        issuer: String,
        audience: String,
        expiresIn: TimeInterval
    ) async throws -> String {
        try await MainActor.run(body: {
            try JWT.makeMockToken(
                userId: userId,
                name: name,
                issuer: issuer,
                audience: audience,
                expiresIn: expiresIn
            )
        })
    }
}


//
//  AuthStore.swift
//  JWT Auth
//
//  Created by Israel Manzo on 5/2/26.
//

import SwiftUI
import Combine

// MARK: - Auth

@MainActor
final class AuthStore: ObservableObject {
    @Published private(set) var token: String?
    @Published private(set) var refreshToken: String?
    @Published private(set) var claims: JWTClaims?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // For a real app, store tokens in Keychain (UserDefaults is fine for a mock/demo token).
    // Kept for backward compatibility with earlier demo iterations.
    static let tokenDefaultsKey = "auth.jwt.accessToken"
    
    private var refreshLoopTask: Task<Void, Never>?
    
    init() {
        Task { await bootstrap() }
    }
    
    var isAuthenticated: Bool {
        guard let token, let claims else { return false }
        return !token.isEmpty && !claims.isExpired
    }
    
    func login(username: String, password: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            // Mocked "call": in a real flow this is where you'd exchange credentials for a JWT
            // from your backend (and handle non-200s, MFA, lockouts, etc).
            try await Task.sleep(nanoseconds: 350_000_000) // simulate network latency
            let displayName = username.isEmpty ? "Mock User" : username
            let userId = UUID().uuidString
            let accessToken = try JWT.makeMockToken(userId: userId, name: displayName)
            let refreshToken = try JWT.makeMockToken(
                userId: userId,
                name: displayName,
                issuer: "com.israelmanzo.jwt-auth.mock.refresh",
                audience: "jwt-auth-demo-refresh",
                expiresIn: 60 * 60 * 24 * 7
            )
            await TokenManager.shared.setTokens(AuthTokens(accessToken: accessToken, refreshToken: refreshToken))
            await syncFromTokenManager()
        } catch {
            errorMessage = "Login failed."
        }
    }
    
    func logout() {
        refreshLoopTask?.cancel()
        refreshLoopTask = nil
        Task { await TokenManager.shared.clear() }
        setLocalTokens(access: nil, refresh: nil)
        errorMessage = nil
    }
    
    func refreshSession() async {
        errorMessage = nil
        do {
            _ = try await TokenManager.shared.refresh()
            await syncFromTokenManager()
        } catch {
            logout()
            errorMessage = "Session expired."
        }
    }
    
    private func bootstrap() async {
        await syncFromTokenManager()
        // Trigger a refresh at launch if needed (expired or near-expiry).
        do {
            _ = try await TokenManager.shared.validAccessToken(minValidity: 60)
            await syncFromTokenManager()
        } catch {
            // If we can't produce a valid token, clear state.
            logout()
        }
    }
    
    private func syncFromTokenManager() async {
        let tokens = await TokenManager.shared.currentTokens()
        setLocalTokens(access: tokens?.accessToken, refresh: tokens?.refreshToken)
        scheduleRefreshLoop()
    }
    
    private func setLocalTokens(access: String?, refresh: String?) {
        token = access
        refreshToken = refresh
        
        claims = nil
        if let access, !access.isEmpty {
            claims = try? JWT.decodeClaims(from: access)
        }
        
        if token == nil || token?.isEmpty == true {
            refreshLoopTask?.cancel()
            refreshLoopTask = nil
        }
    }
    
    private func scheduleRefreshLoop() {
        refreshLoopTask?.cancel()
        guard let claims, !claims.isExpired else { return }
        
        // Refresh a bit before expiry to avoid 401s during requests.
        let refreshSkew: TimeInterval = 60
        let secondsUntilExpiry = TimeInterval(claims.exp) - Date().timeIntervalSince1970
        let delay = max(0, secondsUntilExpiry - refreshSkew)
        
        refreshLoopTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            guard let self, !Task.isCancelled else { return }
            await self.refreshSession()
        }
    }
}

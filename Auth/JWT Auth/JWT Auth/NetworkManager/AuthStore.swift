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
    @Published private(set) var claims: JWTClaims?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // For a real app, store tokens in Keychain (UserDefaults is fine for a mock/demo token).
    static let tokenDefaultsKey = "auth.jwt.token"
    
    init() {
        let saved = UserDefaults.standard.string(forKey: Self.tokenDefaultsKey)
        setToken(saved)
        validateAndNormalize()
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
            let token = try JWT.makeMockToken(userId: UUID().uuidString, name: displayName)
            setToken(token)
            validateAndNormalize()
        } catch {
            errorMessage = "Login failed."
        }
    }
    
    func logout() {
        setToken(nil)
        errorMessage = nil
    }
    
    private func setToken(_ newValue: String?) {
        token = newValue
        if let newValue, !newValue.isEmpty {
            UserDefaults.standard.set(newValue, forKey: Self.tokenDefaultsKey)
        } else {
            UserDefaults.standard.removeObject(forKey: Self.tokenDefaultsKey)
        }
        
        claims = nil
        if let newValue, !newValue.isEmpty {
            claims = try? JWT.decodeClaims(from: newValue)
        }
    }
    
    private func validateAndNormalize() {
        guard let token else { return }
        guard let claims else {
            logout()
            errorMessage = "Invalid token."
            return
        }
        if claims.isExpired {
            // Small UX choice: clear the saved token so the app returns to a clean logged-out state.
            logout()
            errorMessage = "Session expired."
            return
        }
        // keep token as-is if it decodes and isn't expired
        _ = token
    }
}

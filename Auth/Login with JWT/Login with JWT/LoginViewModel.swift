//
//  LoginViewModel.swift
//  Login with JWT
//
//  Created by Israel Manzo on 5/3/26.
//

import SwiftUI
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    /// UI input fields.
    @Published var email = ""
    @Published var password: String = ""

    /// UI state.
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    /// Source of truth for whether we should show Home vs Login.
    @Published var isAuthenticated: Bool = false
    
    /// Handles secure storage and refresh decisions for tokens.
    private let tokenManager = TokenManager.shared
    
    init() {
        isAuthenticated = tokenManager.isAuthenticated
    }

    // MARK: - Derived session info (used by views)

    /// Email decoded from the JWT payload (when present).
    var currentUserEmail: String? { tokenManager.currentUserEmail }

    /// Subject/user id decoded from the JWT payload (when present).
    var currentUserId: String? { tokenManager.currentUserId }

    /// Access token (secret). Prefer not to show in UI; if you do, truncate.
    var accessToken: String? { tokenManager.accessToken }

    /// Token expiration derived from the server `expires_in` + `issuedAt`.
    var tokenExpirationDate: Date? { (try? tokenManager.getToken())?.expirationDate }

    var tokenIsNearExpiry: Bool { (try? tokenManager.getToken())?.isNearExpired ?? false }
    
    /// Authenticates against the server and persists the resulting token securely.
    func login() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let token = try await AuthApi.login(email: email, password: password)
            try tokenManager.saveToken(token)
            isAuthenticated = true
            clearFields()
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Login failed."
            isAuthenticated = false
        }
    }
    
    /// Logs the user out by clearing stored token(s).
    func logout() {
        try? tokenManager.clearToken()
        isAuthenticated = false
        clearFields()
    }
    
    /// Attempts a refresh if the token is close to expiry. If refresh fails, we log out.
    func refreshIfNeeded() async {
        do {
            try await tokenManager.refreshTokenIfNeeded()
            isAuthenticated = tokenManager.isAuthenticated
        } catch {
            // Refresh failed — force re-login
            logout()
        }
    }
    
    private func clearFields() {
        email = ""
        password = ""
    }
}

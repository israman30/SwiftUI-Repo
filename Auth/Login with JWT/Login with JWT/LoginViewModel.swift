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
    @AppStorage("jwt") var jwt: String = ""
    @Published var email = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    
    private let tokenManager = TokenManager.shared
    
    init() {
        isAuthenticated = tokenManager.isAuthenticated
    }
    
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
    
    func logout() {
        try? tokenManager.clearToken()
        isAuthenticated = false
        clearFields()
    }
    
    func refreshIfNeeded() async {
        do {
            try await tokenManager.refreshTokenIfNeeded()
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

//
//  LoginViewModel.swift
//  Login Flow
//
//  Created by Israel Manzo on 5/5/26.
//

import SwiftUI
import Combine

/// View model backing `LoginView`.
///
/// ## Responsibilities
/// - Holds form input (`email`, `password`) and derived validation (`isFormValid`).
/// - Exposes UI state for progress/error rendering (`isLoading`, `errorMessage`).
/// - Performs async sign-in via `AuthAPI` and flips `isAuthenticated` on success.
///
/// ## Usage
/// Call `await login()` from UI actions (button tap or keyboard submit).
@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    
    var isFormValid: Bool {
        isValidEmail && password.count >= 8
    }
    
    private var isValidEmail: Bool {
        email.contains("@") && email.contains(".")
    }
    
    /// Attempts to authenticate with the provided email/password.
    ///
    /// On success:
    /// - `AuthAPI` stores a token via `TokenManager`
    /// - `isAuthenticated` becomes `true` (the view can then navigate)
    func login() async {
        guard isFormValid else {
            errorMessage = "Please enter a valid email and password."
            return
        }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            _ = try await AuthAPI.login(email: email, password: password)
            isAuthenticated = true
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription
            ?? "Login failed. Please try again."
        }
    }
}

//
//  LoginViewModel.swift
//  Login Flow
//
//  Created by Israel Manzo on 5/5/26.
//

import SwiftUI
import Combine

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

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
    
    func login() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let token = try await AuthAPI.login(email: email, password: password)
            jwt = token
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Login failed."
        }
    }
}

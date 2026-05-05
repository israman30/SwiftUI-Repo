//
//  AppCoordinator.swift
//  Login Flow
//
//  Created by Israel Manzo on 5/5/26.
//

import SwiftUI
import Combine

enum AppRoute: Equatable {
    case splash
    case login
    case signup
    case main
}

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var route: AppRoute = .splash
    private let tokenManager = TokenManager.shared
    
    init() {
        checkAuthState()
    }
    
    func navigate(to route: AppRoute) {
        withAnimation {
            self.route = route
        }
    }
    
    func gotToLogin() {
        goToLogin()
    }
    
    func goToLogin() {
        navigate(to: .login)
    }
    
    func goToSignup() {
        goToSignUp()
    }
    
    func goToSignUp() {
        navigate(to: .signup)
    }
    
    func goToMain() {
        navigate(to: .main)
    }
    
    func logout() {
        tokenManager.clearToken()
        navigate(to: .login)
    }
    
    func checkAuthState() {
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            withAnimation {
                self.route = tokenManager.isAuthenticated ? .main : .login
            }
        }
    }
}

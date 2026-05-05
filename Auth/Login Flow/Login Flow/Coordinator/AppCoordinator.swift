//
//  AppCoordinator.swift
//  Login Flow
//
//  Created by Israel Manzo on 5/5/26.
//

import SwiftUI
import Combine

/// The set of high-level routes used by `ContentView` to switch between screens.
///
/// This is intentionally minimal (splash → auth → main) to keep the sample focused.
enum AppRoute: Equatable {
    case splash
    case login
    case signup
    case main
}

/// Central navigation/state coordinator for the login flow.
///
/// ## How it works
/// - `ContentView` observes `route` and swaps screens accordingly.
/// - `checkAuthState()` simulates an app launch check and routes to `.main` if a token exists.
/// - `logout()` clears the stored token and routes back to `.login`.
///
/// ## Usage
/// Create it once at the root and inject it as an environment object:
///
/// - `@StateObject private var coordinator = AppCoordinator()`
/// - `.environmentObject(coordinator)`
@MainActor
final class AppCoordinator: ObservableObject {
    @Published var route: AppRoute = .splash
    private let tokenManager = TokenManager.shared
    
    init() {
        checkAuthState()
    }
    
    /// Updates the current route using an animated transition.
    func navigate(to route: AppRoute) {
        withAnimation {
            self.route = route
        }
    }
    
    /// Compatibility helper kept for older call sites.
    func gotToLogin() {
        goToLogin()
    }
    
    /// Routes to the sign-in screen.
    func goToLogin() {
        navigate(to: .login)
    }
    
    /// Compatibility helper kept for older call sites.
    func goToSignup() {
        goToSignUp()
    }
    
    /// Routes to the sign-up screen.
    func goToSignUp() {
        navigate(to: .signup)
    }
    
    /// Routes to the main app shell after successful authentication.
    func goToMain() {
        navigate(to: .main)
    }
    
    /// Clears authentication state and returns to the sign-in screen.
    func logout() {
        tokenManager.clearToken()
        navigate(to: .login)
    }
    
    /// Determines the initial route at app launch.
    ///
    /// In a real app, this would validate a refresh token / session with your backend.
    func checkAuthState() {
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            withAnimation {
                self.route = tokenManager.isAuthenticated ? .main : .login
            }
        }
    }
}

//
//  AuthCoordinator.swift
//  Auth Coordinator
//
//  Created by Israel Manzo on 4/13/24.
//

import Foundation
import SwiftUI

enum AuthPage {
    case login
    case forgotPassword
}

final class AuthCoordinator: Hashable {
    
    @Binding var navigationPath: NavigationPath
    
    private var id: UUID
    private var output: Output?
    private var page: AuthPage
    
    struct Output {
        var goToMain: () -> ()
    }
    
    init(page: AuthPage, navigationPath: Binding<NavigationPath>, output: Output? = nil) {
        id = UUID()
        self.page = page
        self.output = output
        self._navigationPath = navigationPath
    }
    
    @ViewBuilder
    func view() -> some View {
        switch self.page {
        case .login:
            loginView()
        case .forgotPassword:
            forgotPasswordView()
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: AuthCoordinator,rhs: AuthCoordinator) -> Bool {
        lhs.id == rhs.id
    }
    
    private func loginView() -> some View {
        let loginView = LoginView(output: .init(goToMain: {
            self.output?.goToMain()
        }, goToForgotPassword: {
            self.push(
                AuthCoordinator(page: .forgotPassword, navigationPath: self.$navigationPath)
            )
        }))
        return loginView
    }
    
    private func forgotPasswordView() -> some View {
        let forgotPassword = ForgotPasswordView(output: .init(goToForgotPasswordSite: {
            self.gotToForgotPasswordSite()
        }))
        return forgotPassword
    }
    
    private func gotToForgotPasswordSite() {
        if let url = URL(string: "somesite.com") {
            UIApplication.shared.open(url)
        }
    }
    
    func push<T>(_ value: T) where T: Hashable {
        navigationPath.append(value)
    }
}

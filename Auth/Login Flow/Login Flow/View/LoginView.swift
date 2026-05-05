//
//  LoginView.swift
//  Login Flow
//
//  Created by Israel Manzo on 5/5/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject private var coordinator: AppCoordinator
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email
        case password
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                header
                    .padding(.top, 56)
                    .padding(.bottom, 36)
                
                formFields
                    .padding(.horizontal, 24)
                
                forgotPassword
                    .padding(.top, 10)
                
                loginButton
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                
                errorView
                    .padding(.horizontal, 24)
                
                signUpPrompt
                    .padding(.top, 24)
                    .padding(.bottom, 40)
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollDismissesKeyboard(.interactively)
        .onAppear { focusedField = .email }
        .onChange(of: viewModel.isAuthenticated) { _, authenticated in
            if authenticated {
                coordinator.goToMain()
            }
        }
    }
    
    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)
            
            Text("Welcome back")
                .font(.title.bold())
            
            Text("Sign in to your account")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var formFields: some View {
        VStack(spacing: 14) {
            AuthTextField(
                title: "Email",
                placeholder: "you@example.com",
                text: $viewModel.email,
                keyboardType: .emailAddress,
                contentType: .emailAddress,
                submitLabel: .next
            ) { focusedField = .password }
                .focused($focusedField, equals: .email)
            
            AuthTextField(
                title: "Password",
                placeholder: "Enter your password",
                text: $viewModel.password,
                isSecure: true,
                contentType: .password,
                submitLabel: .go
            ) {
                Task { await viewModel.login() }
            }
            .focused($focusedField, equals: .password)
        }
    }
    
    private var forgotPassword: some View {
        HStack {
            Spacer()
            Button("Forgot password?") {
                // navigate to forgot password flow
            }
            .font(.subheadline)
            .foregroundStyle(.blue)
            .padding(.trailing, 24)
        }
    }
    
    private var loginButton: some View {
        AuthButton(
            title: "Sign In",
            isLoading: viewModel.isLoading,
            isEnabled: viewModel.isFormValid
        ) {
            focusedField = nil
            Task {
                await viewModel.login()
            }
        }
    }
    
    @ViewBuilder
    private var errorView: some View {
        if let error = viewModel.errorMessage {
            ErrorBanner(message: error)
                .padding(.top, 12)
                .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
    
    private var signUpPrompt: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?")
                .foregroundStyle(.secondary)
            Button("Sign up") {
                coordinator.goToSignUp()
            }
            .fontWeight(.semibold)
            .foregroundStyle(.blue)
        }
        .font(.subheadline)
    }


}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let coordinator = AppCoordinator()
        coordinator.route = .login
        return LoginView()
            .environmentObject(coordinator)
    }
}

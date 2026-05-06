//
//  SignUpView.swift
//  Login Flow
//
//  Created by Israel Manzo on 5/5/26.
//

import SwiftUI

/// Registration screen for the login flow.
///
/// ## Implementation notes
/// - Uses `SignUpViewModel` for validation and async registration.
/// - Shows a live `PasswordStrengthView` once the user starts typing a password.
/// - On successful registration, routes back to `.login` (user can then sign in).
///
/// ## Usage
/// Presented by `ContentView` when `AppCoordinator.route == .signup`.
struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @EnvironmentObject var coordinator: AppCoordinator
    @FocusState private var focusedField: Field?
    
    private enum Field { case name, email, password, confirm }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                backButton
                    .padding(.top, 16)
                
                header
                    .padding(.top, 24)
                    .padding(.bottom, 36)
                
                formFields
                    .padding(.horizontal, 24)
                
                passwordStrengthView
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                
                signUpButton
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                
                errorView
                    .padding(.horizontal, 24)
                
                loginPrompt
                    .padding(.top, 24)
                    .padding(.bottom, 40)

            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollDismissesKeyboard(.interactively)
        .onChange(of: viewModel.isRegistered) { _, registered in
            if registered {
                coordinator.goToLogin()
            }
        }
    }
    
    private var backButton: some View {
        HStack {
            Button {
                coordinator.goToLogin()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Sign In")
                }
                .font(.subheadline)
                .foregroundStyle(.blue)
            }
            .padding(.leading, 20)
            Spacer()
        }
    }
    
    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.badge.plus")
                .font(.system(size: 60))
                .foregroundStyle(.blue)
            
            Text("Create account")
                .font(.title.bold())
            
            Text("Start organizing your life")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var formFields: some View {
        VStack(spacing: 14) {
            AuthTextField(
                title: "Full Name",
                placeholder: "John Appleseed",
                text: $viewModel.fullName,
                contentType: .name,
                submitLabel: .next
            ) {
                focusedField = .email
            }
            .focused($focusedField, equals: .name)
            
            AuthTextField(
                title: "Email",
                placeholder: "you@example.com",
                text: $viewModel.email,
                keyboardType: .emailAddress,
                contentType: .emailAddress,
                submitLabel: .next
            ) {
                focusedField = .password
            }
            .focused($focusedField, equals: .email)
            
            AuthTextField(
                title: "Password",
                placeholder: "Min. 8 characters",
                text: $viewModel.password,
                isSecure: true,
                contentType: .newPassword,
                submitLabel: .next
            ) {
                focusedField = .confirm
            }
            .focused($focusedField, equals: .password)
            
            AuthTextField(
                title: "Confirm Password",
                placeholder: "Repeat your password",
                text: $viewModel.confirmPassword,
                isSecure: true,
                contentType: .newPassword,
                submitLabel: .go
            ) {
                Task {
                    await viewModel.signUp()
                }
            }
            .focused($focusedField, equals: .confirm)
        }
    }
    
    @ViewBuilder
    private var passwordStrengthView: some View {
        if !viewModel.password.isEmpty {
            PasswordStrengthView(strength: viewModel.passwordStrength)
                .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
    
    private var signUpButton: some View {
        AuthButton(
            title: "Create Account",
            isLoading: viewModel.isLoading,
            isEnabled: viewModel.isFormValid
        ) {
            focusedField = nil
            Task {
                await viewModel.signUp()
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
    
    private var loginPrompt: some View {
        HStack(spacing: 4) {
            Text("Already have an account?")
                .foregroundStyle(.secondary)
            Button("Sign in") {
                coordinator.goToLogin()
            }
            .fontWeight(.semibold)
            .foregroundStyle(.blue)
        }
        .font(.subheadline)
    }

}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        let coordinator = AppCoordinator()
        coordinator.route = .signup
        return SignUpView()
            .environmentObject(coordinator)
    }
}

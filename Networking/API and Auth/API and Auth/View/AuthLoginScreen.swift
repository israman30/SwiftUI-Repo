//
//  AuthLoginScreen.swift
//  API and Auth
//
//  Created by Israel Manzo on 9/6/25.
//

import SwiftUI

struct AuthLoginScreen: View {
    @State private var email: String = "John Doe"
    @State private var password: String = "password1234"
    @AppStorage("isAuthed") private var isAuthed: Bool = false
    
    @Environment(\.authController) private var auth
    
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private var isValidCredentials: Bool {
        !email.isEmptyOrWhitespace && !password.isEmptyOrWhitespace
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Welcome Back 👋")
                .font(.largeTitle.bold())
                .padding(.top, 40)
            
            Text("Login to continue to your account")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Form {
                Section {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .textContentType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                } header: {
                    Text("Login")
                }
                
                Section {
                    Button {
                        Task { await login() }
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView()
                            }
                            Text(isLoading ? "Logging in..." : "Login")
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .disabled(!isValidCredentials || isLoading)
                    .buttonStyle(.borderedProminent)
                    
                    Button("Forgot password?") {
                        // TODO: Forgot password flow
                    }
                    .font(.footnote)
                    .foregroundColor(.blue)
                }
            }
            .scrollContentBackground(.hidden)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                    .transition(.opacity.combined(with: .slide))
                    .animation(.easeInOut, value: errorMessage)
            }
        }
        .padding()
    }
    
    private func login() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            isAuthed = try await auth.login(with: email, password: password)
        } catch {
            errorMessage = "❌ Login failed: \(error.localizedDescription)"
        }
    }
}


#Preview {
    AuthLoginScreen()
}

//
//  LoginView.swift
//  API and Auth
//
//  Created by Israel Manzo on 9/5/25.
//
/**
 using " https://fakeapi.platzi.com/en/rest/users/ for crud users
 */

import SwiftUI

struct LoginScreen: View {
    @Environment(\.authController) private var auth
    @State private var registrationForm: RegistrationForm = .init()
    @State private var message: String?
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account")
                .font(.largeTitle.bold())
                .padding(.top)
            
            Form {
                Section(header: Text("Your Details")) {
                    TextField("Name", text: $registrationForm.name)
                        .textContentType(.name)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                    
                    TextField("Email", text: $registrationForm.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    SecureField("Password", text: $registrationForm.password)
                        .textContentType(.newPassword)
                }
                
                Section {
                    Button(action: {
                        Task { await signup() }
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                            Text(isLoading ? "Signing up..." : "Sign Up")
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .disabled(!registrationForm.isValid || isLoading)
                    .buttonStyle(.borderedProminent)
                }
            }
            .scrollContentBackground(.hidden)
            
            if let message = message {
                Text(message)
                    .foregroundStyle(message.contains("❌") ? .red : .green)
                    .multilineTextAlignment(.center)
                    .padding()
                    .transition(.opacity.combined(with: .slide))
                    .animation(.easeInOut, value: message)
            }
        }
        .padding()
    }
    
    private func signup() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await auth.signUp(
                name: registrationForm.name,
                email: registrationForm.email,
                password: registrationForm.password
            )
            message = "✅ Signup for \(response.name) completed!"
            registrationForm = .init() // clear form
        } catch {
            message = "❌ Error: \(error.localizedDescription)"
        }
    }
}


#Preview {
    LoginScreen()
}

extension String {
    var isEmptyOrWhitespace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isValidpassword: Bool {
        count > 8
    }
    
    var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return range(of: emailRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

extension LoginScreen {
    private struct RegistrationForm {
        var name: String = "John Doe"
        var email: String = "johndoe@gmail.com"
        var password: String = "password1234"
        
        var isValid: Bool {
            valdidate().isEmpty
        }
        
        func valdidate() -> [String] {
            var errors = [String]()
            
            if name.isEmptyOrWhitespace {
                errors.append("Name is required")
            }
            
            if email.isEmptyOrWhitespace {
                errors.append("Email is required")
            }
            
            if password.isEmptyOrWhitespace {
                errors.append("Password is required")
            }
            
            if !password.isValidpassword {
                errors.append("Password must be at least 8 characters long")
            }
            
            if !email.isEmailValid {
                errors.append("Email is invalid")
            }
            
            return errors
        }
        
    }
}

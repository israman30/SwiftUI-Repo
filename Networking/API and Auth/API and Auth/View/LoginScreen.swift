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
    @State private var message = ""
    
    var body: some View {
        Form {
            TextField("Name", text: $registrationForm.name)
            TextField("Email", text: $registrationForm.email)
            SecureField("Password", text: $registrationForm.password)
            Button("Signup") {
// errors = registrationForm.valdidate()
                Task {
                    await signup()
                }
            }.disabled(!registrationForm.isValid)
            
            // appreach for displaying view messaged when empty fields, toggle errors = registrationForm.valdidate()
//            if !errors.isEmpty {
//                ValidationSummaryView(errors: errors)
//            }
        }
    }
    
    private func signup() async {
        do {
            let response = try await auth.signUp(name: registrationForm.name, email: registrationForm.email, password: registrationForm.password)
            message = "✅ Signup for: \(response.name) completed"
        } catch {
            message = "❎ Error: \(error.localizedDescription)"
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
        var name: String = ""
        var email: String = ""
        var password: String = ""
        
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

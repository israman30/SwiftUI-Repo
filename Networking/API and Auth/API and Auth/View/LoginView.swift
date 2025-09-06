//
//  LoginView.swift
//  API and Auth
//
//  Created by Israel Manzo on 9/5/25.
//

import SwiftUI

struct LoginView: View {
    @State private var registrationForm: RegistrationForm = .init()
    
    var body: some View {
        Form {
            TextField("Name", text: $registrationForm.name)
            TextField("Email", text: $registrationForm.email)
            SecureField("Password", text: $registrationForm.password)
            Button("Signup") {
                // event
            }
            .disabled(!registrationForm.isValid)
        }
    }
    
    
}

#Preview {
    LoginView()
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

extension LoginView {
    private struct RegistrationForm {
        var name: String = ""
        var email: String = ""
        var password: String = ""
        
        var isValid: Bool {
            valdidate().isEmpty
        }
        
        private func valdidate() -> [String] {
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

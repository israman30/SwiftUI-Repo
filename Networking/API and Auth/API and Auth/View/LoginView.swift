//
//  LoginView.swift
//  API and Auth
//
//  Created by Israel Manzo on 9/5/25.
//

import SwiftUI

struct LoginView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    private var isValid: Bool {
        valdidate().isEmpty
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            Button("Signup") {
                // event
            }
        }
    }
    
    private func valdidate() -> [String] {
        var errors = [String]()
        
        if name.isEmptyOrWhitespace {
            errors.append("Name is required")
        } else if email.isEmptyOrWhitespace {
            errors.append("Email is required")
        } else if password.isEmptyOrWhitespace {
            errors.append("Password is required")
        } else {
            errors.append("All fields are required")
        }
        
        if !password.isEmpty, !password.isValidpassword {
            errors.append("Password must be at least 8 characters long")
        }
        
        if !email.isEmpty, !email.isEmailValid {
            errors.append("Email is invalid")
        }
        
        return errors
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
        count >= 8
    }
    
    var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return range(of: emailRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

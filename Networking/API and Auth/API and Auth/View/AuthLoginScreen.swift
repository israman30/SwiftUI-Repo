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
    
    private var isValidCredentials: Bool {
        !email.isEmptyOrWhitespace && !password.isEmptyOrWhitespace
    }
    var body: some View {
        Form {
            Section {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .foregroundStyle(.primary)
                
                SecureField("Password", text: $password)
                    .foregroundStyle(.primary)
            } header: {
                Text("Login")
            }
            
            Section {
                Button("Loging") {
                    Task {
                        await login()
                    }
                }
                .disabled(!isValidCredentials)
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    private func login() async {
        do {
            isAuthed = try await auth.login(with: email, password: password)
            print(isAuthed)
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    AuthLoginScreen()
}

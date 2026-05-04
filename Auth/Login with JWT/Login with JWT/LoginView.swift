//
//  LoginView.swift
//  Login with JWT
//
//  Created by Israel Manzo on 5/3/26.
//

import SwiftUI

struct LoginView: View {
    @AppStorage("jwt") private var jwt: String = ""

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Form {
                Section("Credentials") {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)

                    SecureField("Password", text: $password)
                        .textInputAutocapitalization(.never)
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }

                Section {
                    Button {
                        Task { await login() }
                    } label: {
                        HStack {
                            Text("Login")
                            Spacer()
                            if isLoading {
                                ProgressView()
                            }
                        }
                    }
                    .disabled(isLoading || email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.isEmpty)
                }
            }
            .navigationTitle("Login")
        }
    }

    @MainActor
    private func login() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let token = try await AuthAPI.login(email: email, password: password)
            jwt = token
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Login failed."
        }
    }
}

#Preview {
    LoginView()
}

//
//  LoginView.swift
//  JWT Auth
//
//  Created by Israel Manzo on 5/2/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var auth: AuthStore
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Sign in") {
                    TextField("Username", text: $username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    SecureField("Password", text: $password)
                }
                
                if let message = auth.errorMessage, !message.isEmpty {
                    Section {
                        Text(message)
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    Button {
                        Task { await auth.login(username: username, password: password) }
                    } label: {
                        if auth.isLoading {
                            HStack {
                                ProgressView()
                                Text("Signing in…")
                            }
                        } else {
                            Text("Sign In (Mock JWT)")
                        }
                    }
                    .disabled(auth.isLoading)
                }
            }
            .navigationTitle("JWT Auth")
        }
    }
}

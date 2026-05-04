//
//  LoginView.swift
//  Login with JWT
//
//  Created by Israel Manzo on 5/3/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject var vm = LoginViewModel()
    var body: some View {
        NavigationView {
            Form {
                Section("Credentials") {
                    TextField("Email", text: $vm.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)

                    SecureField("Password", text: $vm.password)
                        .textInputAutocapitalization(.never)
                }

                if let errorMessage = vm.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }

                Section {
                    Button {
                        Task { await vm.login() }
                    } label: {
                        HStack {
                            Text("Login")
                            Spacer()
                            if vm.isLoading {
                                ProgressView()
                            }
                        }
                    }
                    .disabled(vm.isLoading || vm.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.password.isEmpty)
                }
            }
            .navigationTitle("Login")
        }
    }
}

#Preview {
    LoginView()
}

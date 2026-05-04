//
//  ContentView.swift
//  Login with JWT
//
//  Created by Israel Manzo on 5/3/26.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm: LoginViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Home Screen")
                    .font(.title2)

                VStack(alignment: .leading, spacing: 6) {
                    if let email = vm.currentUserEmail {
                        Text("Email: \(email)")
                            .font(.subheadline)
                    }
                    if let userId = vm.currentUserId {
                        Text("User ID: \(userId)")
                            .font(.subheadline)
                    }
                    if let exp = vm.tokenExpirationDate {
                        Text("Expires: \(exp.formatted(date: .abbreviated, time: .shortened))")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    if vm.tokenIsNearExpiry {
                        Text("Token is near expiry (will refresh).")
                            .font(.footnote)
                            .foregroundStyle(.orange)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if let token = vm.accessToken {
                    Text("Access token (truncated): \(token.prefix(24))…")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .textSelection(.enabled)
                }

                Button {
                    Task { await vm.refreshIfNeeded() }
                } label: {
                    Text("Refresh Session")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button(role: .destructive) {
                    vm.logout()
                } label: {
                    Text("Logout")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 8)
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: LoginViewModel())
    }
}

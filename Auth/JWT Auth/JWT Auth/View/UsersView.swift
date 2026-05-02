//
//  UsersView.swift
//  JWT Auth
//
//  Created by Israel Manzo on 5/2/26.
//

import SwiftUI

struct UsersView: View {
    @EnvironmentObject private var auth: AuthStore
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        NavigationStack {
            List {
                if let claims = auth.claims {
                    Section("Token claims") {
                        LabeledContent("Name", value: claims.name)
                        LabeledContent("sub", value: claims.sub)
                        LabeledContent("exp", value: Date(timeIntervalSince1970: TimeInterval(claims.exp)).formatted(date: .abbreviated, time: .standard))
                    }
                }
                
                if let err = vm.errorMessage, !err.isEmpty {
                    Section {
                        Text(err)
                            .foregroundStyle(.red)
                    }
                }
                
                Section("Users") {
                    ForEach(vm.users) { user in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.name)
                            Text(user.email)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Authenticated")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Logout") { auth.logout() }
                }
            }
            .task {
                await vm.loadUsers()
            }
        }
    }
}

//
//  ContentView.swift
//  Login with JWT
//
//  Created by Israel Manzo on 5/3/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("jwt") private var jwt: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Home Screen")
                    .font(.title2)

                if !jwt.isEmpty {
                    Text("JWT: \(jwt)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .textSelection(.enabled)
                }

                Button(role: .destructive) {
                    jwt = ""
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

#Preview {
    ContentView()
}

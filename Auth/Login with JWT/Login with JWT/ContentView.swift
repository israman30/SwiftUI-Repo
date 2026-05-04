//
//  ContentView.swift
//  Login with JWT
//
//  Created by Israel Manzo on 5/3/26.
//

import SwiftUI

struct ContentView: View {
    var onLogout: () -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Home Screen")
                    .font(.title2)

                Button(role: .destructive) {
                    onLogout()
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
        ContentView(onLogout: { })
    }
}

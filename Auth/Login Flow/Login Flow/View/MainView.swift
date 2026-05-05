//
//  MainView.swift
//  Login Flow
//
//  Created by Israel Manzo on 5/5/26.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(.green)
                
                Text("You're signed in")
                    .font(.title.bold())
                
                Text("This is your main app screen.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Button(role: .destructive) {
                    coordinator.logout()
                } label: {
                    Text("Log out")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .padding(.top, 12)
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .padding(.top, 40)
            .navigationTitle("Home")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let coordinator = AppCoordinator()
        coordinator.route = .main
        return MainView()
            .environmentObject(coordinator)
    }
}


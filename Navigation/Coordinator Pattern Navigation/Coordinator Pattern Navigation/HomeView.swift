//
//  HomeView.swift
//  Coordinator Pattern Navigation
//
//  Created by Israel Manzo on 4/3/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var coordinator: Coordinator
    var body: some View {
        NavigationStack {
            VStack {
                Text("Coodinator")
                Button("Go to Product") {
                    coordinator.showProductsList()
                }
                
                Button("Go to sheet") {
                    coordinator.showSheet()
                }
            }
            .navigationTitle("Coordinator")
        }
    }
}

#Preview {
    HomeView()
}


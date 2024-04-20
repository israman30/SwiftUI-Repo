//
//  MainView.swift
//  Passing data DI Coordinators
//
//  Created by Israel Manzo on 4/19/24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button("Tap here") {
                        let model = Model(name: "Tom Sawyer")
                        coordinator.push(.detail(model: model))
                    }
                }
                Section {
                    let model = Model(name: "Tom Sawyer")
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Text("Go to detail too")
                    }

                }
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(Coordinator())
}

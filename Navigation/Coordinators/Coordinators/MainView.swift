//
//  MainView.swift
//  Coordinators
//
//  Created by Israel Manzo on 4/14/24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        List {
            Button("Push view") {
                coordinator.push(.viewA)
            }
            Button("Sheet") {
                coordinator.present(sheet: .display)
            }
            
            Button("Sheet") {
                coordinator.present(fullScreenSheet: .display)
            }
        }
        .navigationTitle("Coordinator")
    }
}

#Preview {
    MainView()
}

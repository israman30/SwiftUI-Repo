//
//  MainView.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        List {
            Section {
                Button("Detail View") {
                    coordinator.push(.detail)
                }
                
                Button("User View") {
                    coordinator.push(.user)
                }
            }
            
            Section {
                Button("Present Sheet") {
                    
                }
                
                Button("Present Full Screen Sheet") {
                    
                }
            }
            
        }
        .navigationTitle("Coordinators")
    }
}

#Preview {
    MainView()
}

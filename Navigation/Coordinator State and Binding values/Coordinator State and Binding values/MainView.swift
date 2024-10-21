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
                Button("Detail View 1") {
                    coordinator.push(.detail)
                }
                
                Button("Detail View 2") {
//                    Text("Detail")
                }
            }
            
            Section {
                Button("Present Sheet") {
                    
                }
                
                Button("Present Full Screen Sheet") {
                    
                }
            }
        }
    }
}

#Preview {
    MainView()
}

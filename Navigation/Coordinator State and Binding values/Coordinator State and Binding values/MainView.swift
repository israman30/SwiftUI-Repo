//
//  MainView.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    @State var isUserLoggedIn: Bool = true
    @State var userActivity: Bool = true
    
    var body: some View {
        VStack {
            List {
                Section {
                    Button {
                        coordinator.push(.detail)
                    } label: {
                        Text("Detail View")
                            .foregroundStyle(Color(.label))
                            .font(.title2)
                            .padding(5)
                    }
                    
                    Button {
                        coordinator.push(.user($isUserLoggedIn))
                    } label: {
                        Text("User View")
                            .foregroundStyle(Color(.label))
                            .font(.title2)
                            .padding(5)
                    }
                }
                
                Section {
                    Button("Present Sheet") {
                        coordinator.present(.infoChannel($userActivity))
                    }
                    
                    Button("Present Full Screen Sheet") {
                        
                    }
                }
                
                Button {
                    self.userActivity.toggle()
                } label: {
                    Text("Toggle activity")
                        .foregroundStyle(userActivity ? .green : .red)
                        .font(.title2)
                        .padding(5)
                }
            }
            .navigationTitle("Coordinators")
            
        }
    
    }
}

#Preview {
    MainView()
}

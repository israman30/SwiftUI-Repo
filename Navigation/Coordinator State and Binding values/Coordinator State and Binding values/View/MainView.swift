//
//  MainView.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var myViewModel: MyViewModel
    @State var isUserLoggedIn: Bool = true
    
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
                    
                    Button("Other Page") {
                        coordinator.push(.secondPage)
                    }
                    
                } header: {
                    HStack {
                        Text("\(myViewModel.username) - \(myViewModel.userEmail)")
                    }
                }
                
                Section {
                    Button("Present Sheet") {
                        coordinator.present(.infoChannel($myViewModel.userActivity))
                    }
                    
                    Button("Present Full Screen Sheet") {
                        coordinator.presentFull(.fullScreen)
                    }
                }
                
                Button {
                    myViewModel.userActivity.toggle()
                } label: {
                    Text("Toggle activity")
                        .foregroundStyle(myViewModel.userActivity ? .green : .red)
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
        .environmentObject(MyViewModel())
}

//
//  MainView.swift
//  Passing data DI Coordinators
//
//  Created by Israel Manzo on 4/19/24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    @StateObject var vm: UsersViewModel
    
    init() {
        self._vm = StateObject(wrappedValue: UsersViewModel(services: NetworkServices()))
    }
    
    var body: some View {
        VStack {
            Section {
                List(vm.users, id: \.id) { user in
                    Button {
                        coordinator.push(.detail(user: user))
                    } label: {
                        HStack {
                            Text(user.name)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                .navigationTitle("Coordinators")
            }
            .task {
                await vm.getUsers()
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(Coordinator())
}

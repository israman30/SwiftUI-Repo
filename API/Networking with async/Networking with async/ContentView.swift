//
//  ContentView.swift
//  Networking with async
//
//  Created by Israel Manzo on 1/11/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm: UsersViewModelImplementation
    
    init() {
        self._vm = StateObject(wrappedValue: UsersViewModelImplementation(services: NetworkServicesImplementation()))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.users, id: \.id) { user in
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.title2)
                        Text(user.website)
                            .foregroundColor(.gray)
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.grouped)
            .task {
                await vm.getUsers()
            }
            .navigationTitle("Fetch Stuff")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



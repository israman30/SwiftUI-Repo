//
//  ContentView.swift
//  Seach with Combine
//
//  Created by Israel Manzo on 1/21/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var vm = UsersViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.filteredUsers, id: \.self) { user in
                    Text(user.name)
                }
                
            }
            .navigationTitle("Avengers")
            .searchable(text: $vm.searchText)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

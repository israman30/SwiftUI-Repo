//
//  ContentView.swift
//  Seach with Combine
//
//  Created by Israel Manzo on 1/21/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var vm = UsersViewModel()
    @State var searchText = ""
    
    var filterdUser: [Users] {
        if searchText.isEmpty {
            return vm.users
        } else {
            return vm.users.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filterdUser, id: \.self) { user in
                    Text(user.name)
                }
                
            }
            .navigationTitle("Avengers")
            .searchable(text: $searchText)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

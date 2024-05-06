//
//  ContentView.swift
//  NavigationStack
//
//  Created by Israel Manzo on 5/5/24.
//

import SwiftUI

struct Users: Identifiable {
    let name: String
    var id: String {
        name
    }
    
    
}

class ViewModel: ObservableObject {
    
    private var users: Users
    
    init(users: Users) {
        self.users = users
    }
}

struct ContentView: View {

    @State var sample: [Users] = [
        Users(name: "John Doe"),
        Users(name: "Fred Flinstone"),
        Users(name: "Peter Parker"),
        Users(name: "Tom Sawyer")
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(sample, id: \.id) { users in
                    Text(users.name)
                }
            }
            .navigationTitle("Navigation Stack")
        }
    }
}

#Preview {
    ContentView()
}

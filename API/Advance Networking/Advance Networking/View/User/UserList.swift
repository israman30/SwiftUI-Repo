//
//  UserList.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI
import Combine

// https://jsonplaceholder.typicode.com/users

/**
 "id": 1,
 "name": "Leanne Graham",
 "username": "Bret",
 "email": "Sincere@april.biz",
 */

struct User: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let username: String
    let email: String
}

@MainActor
class UserViewModel: ObservableObject {
    @Published var users = [User]()
    
    func fetchUser() async throws {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        users = try JSONDecoder().decode([User].self, from: data)
    }
}

struct UserList: View {
    @StateObject var vm = UserViewModel()
    var body: some View {
        List(vm.users) { user in
            Text(user.name)
        }
        .task {
            do {
                try await vm.fetchUser()
            } catch {
                
            }
        }
    }
    
    func addUser() {
        
    }
}

#Preview {
    UserList()
}

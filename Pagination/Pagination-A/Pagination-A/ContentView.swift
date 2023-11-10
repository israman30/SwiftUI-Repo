//
//  ContentView.swift
//  Pagination-A
//
//  Created by Israel Manzo on 11/10/23.
//

import SwiftUI

// https://reqres.in/api/users?page=2

struct UserList: Decodable {
    let page: Int
    let per_page: Int
    let total: Int
    let total_pages: Int
    let data: [User]
}

struct User: Decodable, Hashable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let avatar: URL
}

@MainActor
class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    
    var totalPages = 0
    var page = 1
    
    func getUsers() async throws {
        guard let url = URL(string: "https://reqres.in/api/users?page=2") else {
            fatalError("Wrnog url")
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        do {
            let users = try JSONDecoder().decode(UserList.self, from: data).data
            self.users = users
        } catch {
            print("Error decoding json: \(error.localizedDescription)")
        }
    }
    
    func load() async  {
        try! await getUsers()
    }
    
}

struct ContentView: View {
    
    @StateObject var vm = UserViewModel()
    
    var body: some View {
        List(vm.users, id: \.id) { user in
            Text(user.email)
        }
        .task {
            await vm.load()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

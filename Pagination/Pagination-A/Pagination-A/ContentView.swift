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
final class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    
    private var totalPages = 0
    private var page = 1
    
    func loadMoreContent(user: User) async {
        let userIndex = self.users.index(self.users.endIndex, offsetBy: -1)
        if userIndex == user.id, (page + 1) <= totalPages {
            page += 1
            try! await getUsers()
        }
    }
    
    private func getUsers() async throws {
        guard let url = URL(string: "https://reqres.in/api/users?page=\(page)") else {
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
            UserView(user: user)
                .onAppear {
                    Task {
                        await vm.loadMoreContent(user: user)
                    }
                }
        }
        .listStyle(.grouped)
        .task {
            await vm.load()
        }
    }
}

#Preview {
    ContentView()
}

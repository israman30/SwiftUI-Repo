//
//  ContentView.swift
//  Pagination Simple Sample
//
//  Created by Israel Manzo on 5/2/26.
//

import SwiftUI
import Combine

struct Constants {
    static var endopint = "https://jsonplaceholder.typicode.com"
}

struct User: Decodable, Identifiable {
    var id: Int
    var name: String
    var username: String
    var email: String
}

class ViewModel: ObservableObject {
    @Published var users: [User] = []
    
    private let services: NetworkServices
    
    init(_ services: NetworkServices) {
        self.services = services
    }
    
    func loadUser() async {
        do {
            users = try await services.fetchUsers()
        } catch {
            print("Something when wrong: \(error)")
        }
    }
}

struct ContentView: View {
    
    @StateObject var vm = ViewModel(NetworkServices())
    
    var body: some View {
        VStack {
            List(vm.users) { user in
                Text(user.name)
            }
            .task {
                await vm.loadUser()
            }
        }
    }
}

#Preview {
    ContentView()
}

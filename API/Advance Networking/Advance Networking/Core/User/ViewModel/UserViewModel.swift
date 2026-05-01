//
//  UserViewModel.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI
import Combine

@MainActor
class UserViewModel: ObservableObject {
    @Published var users = [User]()
    
    func fetchUser() async throws {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        users = try JSONDecoder().decode([User].self, from: data)
    }
}

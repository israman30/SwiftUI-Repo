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
    
    var loadingState: LoadingState<[User]> = .idle
    
    private let service: UserServiceProtocol
    
    init(service: UserServiceProtocol) {
        self.service = service
    }
    
    func loadUsers() async {
        loadingState = .loading
        do {
            self.users = try await service.fetchUser()
        } catch {
            loadingState = .error(error.localizedDescription)
            print("DEBUG: fetching users \(error)")
        }
    }
    
    func createUser(_ payload: User) async {
        do {
            let newUser = try await service.create(payload)
            self.users.insert(newUser, at: 0)
        } catch {
            print("DEBUG: updating users \(error)")
        }
    }
    
    func updateUser(_ id: Int, payload: UpdateUser) async {
        guard let index = users.firstIndex(where: { $0.id == id}) else { return }
        do {
            let newUser = try await service.update(id, payload: payload)
            self.users[index] = newUser
        } catch {
            print("DEBUG: updating users \(error)")
        }
    }
}

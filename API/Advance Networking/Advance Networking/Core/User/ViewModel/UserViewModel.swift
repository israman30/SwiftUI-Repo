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
    
    @Published var loadingState: LoadingState<[User]> = .idle
    
    private let service: UserServiceProtocol
    
    init(service: UserServiceProtocol) {
        self.service = service
    }
    
    func loadUsers() async {
        loadingState = .loading
        do {
            let users = try await service.fetchUser()
            loadingState = users.isEmpty ? .empty : .loaded(users)
        } catch {
            loadingState = .error(error.localizedDescription)
            print("DEBUG: fetching users \(error)")
        }
    }
    
    func createUser(_ payload: User) async {
        do {
            let newUser = try await service.create(payload)
            insertOrStart(newUser)
        } catch {
            print("DEBUG: updating users \(error)")
        }
    }
    
    func updateUser(_ id: Int, payload: UpdateUser) async {
        do {
            let updatedUser = try await service.update(id, payload: payload)
            updatePostIfLoaded(updatedUser)
        } catch {
            print("DEBUG: updating users \(error)")
        }
    }
    
    private func insertOrStart(_ user: User) {
        switch loadingState {
        case .loaded(var users):
            users.insert(user, at: 0)
            loadingState = .loaded(users)
        default:
            loadingState = .loaded([user])
        }
    }
    
    private func updatePostIfLoaded(_ user: User) {
        guard case .loaded(var users) = loadingState else {
            return
        }
        guard let index = users.firstIndex(where: { $0.id == user.id }) else { return }
        users[index] = user
        loadingState = .loaded(users)
    }
    
}

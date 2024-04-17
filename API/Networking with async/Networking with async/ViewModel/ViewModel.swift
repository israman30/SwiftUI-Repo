//
//  ViewModel.swift
//  Networking with async
//
//  Created by Israel Manzo on 1/11/23.
//

import Foundation

protocol UsersViewModel: ObservableObject {
    func getUsers() async
}

@MainActor
final class UsersViewModelImplementation: UsersViewModel {
    
    @Published private(set) var users = [User]()
    
    private let services: NetworkServices
    
    init(services: NetworkServices) {
        self.services = services
    }
    
    func getUsers() async {
        do {
            self.users = try await services.fetchUsers()
        } catch {
            print("Some error")
        }
    }
}

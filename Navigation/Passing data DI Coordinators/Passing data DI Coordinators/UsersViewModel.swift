//
//  UsersViewModel.swift
//  Passing data DI Coordinators
//
//  Created by Israel Manzo on 4/20/24.
//

import SwiftUI

@MainActor
final class UsersViewModel: ObservableObject {
    
    @Published var users = [Users]()
    
    private let services: NetworkServices
    
    init(services: NetworkServices) {
        self.services = services
    }
    
    func getUsers() async {
        do {
            self.users = try await services.fetchData()
        } catch {
            print("Some error")
        }
    }
}

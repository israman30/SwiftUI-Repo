//
//  UserViewModel.swift
//  Seach with Combine
//
//  Created by Israel Manzo on 1/23/23.
//

import SwiftUI
import Combine

class UsersViewModel: ObservableObject {
    @Published var users = [Users]()
    @Published var searchText = ""
    @Published var searchResult = [Users]()
    private var cancellables = Set<AnyCancellable>()
    
    var data = [Users]()
    
    var filteredUsers: [Users] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    init() {
        users = [
            .init(name: "Tony Stark"),
            .init(name: "Stever Rogers"),
            .init(name: "Bruce Banner"),
            .init(name: "Natasha"),
            .init(name: "Jeremy Rener")
        ]
        addSubcriber()
    }
    
    func addSubcriber() {
        $searchText
            .receive(on: RunLoop.main)
            .sink { newUser in
                var filteredUsers: [Users] {
                    if self.searchText.isEmpty {
                        return self.users
                    } else {
                        return self.users.filter { $0.name.localizedCaseInsensitiveContains(self.searchText) }
                    }
                }
            }
            .store(in: &cancellables)
            
    }
    
    func searchQuery(string: String = "") {
        searchResult = string.isEmpty ? data : data.filter { $0.name.contains(string) }
    }
}

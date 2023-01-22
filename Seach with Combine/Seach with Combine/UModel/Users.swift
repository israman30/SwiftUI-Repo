//
//  Users.swift
//  Seach with Combine
//
//  Created by Israel Manzo on 1/21/23.
//

import SwiftUI

struct Users: Hashable {
    let name: String
}

class UsersViewModel: ObservableObject {
    @Published var users = [Users]()
    init() {
        users = [
            .init(name: "Tony Stark"),
            .init(name: "Stever Rogers"),
            .init(name: "Bruce Banner"),
            .init(name: "Natasha"),
            .init(name: "Jeremy Rener")
        ]
    }
}

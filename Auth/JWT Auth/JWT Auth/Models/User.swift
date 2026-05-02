//
//  User.swift
//  JWT Auth
//
//  Created by Israel Manzo on 5/2/26.
//

import Foundation

struct User: Decodable, Identifiable {
    var id: Int
    var name: String
    var username: String
    var email: String
}

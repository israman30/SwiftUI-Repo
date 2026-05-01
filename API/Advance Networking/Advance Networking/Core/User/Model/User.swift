//
//  User.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import Foundation

struct User: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let username: String
    let email: String
}

struct UpdateUser: Encodable {
    let name: String?
    let email: String?
}

struct CheckEmailAvailability {
    let email: String
}

struct CheckEmailAvailabilityResponse {
    let isAvailable: Bool
}

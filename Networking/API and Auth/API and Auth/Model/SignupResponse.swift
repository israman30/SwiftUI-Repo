//
//  SignupResponse.swift
//  API and Auth
//
//  Created by Israel Manzo on 9/6/25.
//

import Foundation

struct SignupResponse: Codable {
    let email: String
    let password: String
    let name: String
    let avatar: URL
    let role: String
    let id: String
}

struct SignupRequest: Codable {
    let name: String
    let email: String
    let password: String
    let avatar: URL
}

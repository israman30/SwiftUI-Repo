//
//  AuthController.swift
//  API and Auth
//
//  Created by Israel Manzo on 9/6/25.
//

import Foundation

struct AuthController {
    
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = .init()) {
        self.networkCl ient = networkClient
    }
}

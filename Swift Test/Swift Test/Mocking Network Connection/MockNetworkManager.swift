//
//  MockNetworkManager.swift
//  Swift Test
//
//  Created by Israel Manzo on 1/4/25.
//

import SwiftUI

class MockNetworkManager: Networking {
    func fetPosts() async throws -> [Post] {
        []
    }
    
    func createPost(content: String) async throws -> Post {
        Post(userId: 0001, id: 0001, title: content, body: content)
    }
}


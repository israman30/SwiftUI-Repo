//
//  MyViewModel.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI
import Combine

@MainActor
class MyViewModel: ObservableObject {
    @Published var posts = [Post]()
    private var service: PostServiceProtocol
    
    init(service: PostServiceProtocol) {
        self.service = service
    }
    
    func fetchPost() async {
        do {
            self.posts = try await service.fetchPost()
        } catch {
            print("DEBUG: something went wrong: \(error)")
        }
    }
}


//
//  ContentView.swift
//  Network Logging & Observability
//
//  Created by Israel Manzo on 5/2/26.
//

import SwiftUI

// https://jsonplaceholder.typicode.com/posts

struct Post: Decodable, Identifiable {
    var userId: Int
    var id: Int
    var title: String
}

struct NetworkManager {
    func fetchPost() async throws -> [Post] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              (200...300).contains(response.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode([Post].self, from: data)
    }
}

@Observable
class ViewModel {
    var posts = [Post]()
    
    private let services: NetworkManager
    
    init(_ services: NetworkManager) {
        self.services = services
    }
    
    func loadPosts() async {
        do {
            self.posts = try await services.fetchPost()
        } catch {
            print("Error loading posts: \(error)")
        }
    }
}

struct ContentView: View {
    @State var vm = ViewModel(NetworkManager())
    var body: some View {
        VStack {
            List(vm.posts) { post in
                Text(post.title)
            }
            .task {
                await vm.loadPosts()
            }
        }
    }
}

#Preview {
    ContentView()
}

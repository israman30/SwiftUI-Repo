//
//  PostListView.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI
import Combine

// https://jsonplaceholder.typicode.com/posts

class ProductNetwork {
    static var shared = ProductNetwork()
    func fetchPost() async throws -> [Post] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode([Post].self, from: data)
    }
}

@MainActor
class MyViewModel: ObservableObject {
    @Published var posts = [Post]()
    private var product = ProductNetwork()
    
    func fetchPost() async {
        do {
            self.posts = try await self.product.fetchPost()
        } catch {
            print("DEBUG: something went wrong: \(error)")
        }
    }
}

struct PostListView: View {
    var vm = MyViewModel()
    var body: some View {
        List(vm.posts) { item in
            Text(item.title)
        }
        .task {
            await vm.fetchPost()
        }
    }
}

#Preview {
    PostListView()
}

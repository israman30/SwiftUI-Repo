//
//  PostListView.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI
import Combine

// https://jsonplaceholder.typicode.com/posts

struct PostListView: View {
    @StateObject var vm = MyViewModel(service: ProductNetwork())
    var body: some View {
        NavigationView {
            List(vm.posts) { item in
                Text(item.title)
            }
            .navigationTitle("Post")
            .toolbar {
                Button {
                    Task {
                        await submit()
                    }
                } label: {
                    Text("Post")
                }
            }
        }
        .task {
            await vm.fetchPost()
        }
    }
    
    func submit() async {
        let newPost = CreatedPost(userId: 5, id: 5, title: "Post Added", body: "This is teh body of a new post")
        await vm.createPost(newPost)
    }
}

#Preview {
    PostListView()
}

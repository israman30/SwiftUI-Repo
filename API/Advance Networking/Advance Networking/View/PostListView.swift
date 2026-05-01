//
//  PostListView.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI
import Combine

// https://jsonplaceholder.typicode.com/posts

/// SwiftUI screen that renders a list of posts and demonstrates basic CRUD actions.
///
/// The view owns a `@StateObject` view model so the model is created once per view lifecycle and
/// survives SwiftUI view redraws.
struct PostListView: View {
    // In production code, you may prefer injecting this from above (App/Coordinator) to avoid
    // constructing concrete services directly inside the view.
    @StateObject var vm = MyViewModel(service: ProductNetwork())
    
    var body: some View {
        NavigationView {
            List(vm.posts) { item in
                Text(item.title)
            }
            .navigationTitle("Post")
            .toolbar {
                Button {
                    // Wrap async work in a `Task` so it can be called from a synchronous button tap.
                    Task {
                        await submit()
                    }
                } label: {
                    Text("Post")
                }
            }
        }
        .task {
            // Runs once when the view appears to populate initial UI state.
            await render()
        }
        .refreshable {
            // Pull-to-refresh triggers the same fetch logic.
            await render()
        }
    }
    
    /// Fetches posts through the view model.
    func render() async {
        await vm.fetchPost()
    }
    
    /// Demo create call with hard-coded payload.
    ///
    /// This shows the flow from UI → view model → service → network and back to UI state updates.
    func submit() async {
        let newPost = CreatedPost(id: 6090909, title: "Post Added", body: "This is teh body of a new post")
        await vm.createPost(newPost)
    }
    
    /// Demo update call. (Not currently wired into the UI.)
    func update(_ id: Int) async {
        let updatedPost = UpdatePost(title: "Upated post", body: "New bddy")
        await vm.update(id, payload: updatedPost)
    }
}

#Preview {
    PostListView()
}

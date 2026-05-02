//
//  PostListView.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI
import Combine

// https://jsonplaceholder.typicode.com/posts

/// Displays posts and demonstrates basic CRUD actions.
///
/// The main UI renders from `vm.loadingState`:
/// - `idle`/`loading`: show `ProgressView`
/// - `empty`: show empty message
/// - `loaded([Post])`: show list
/// - `error`: show error message
///
/// Write operations (create/update/delete) are tracked separately via `vm.mutatingState` so the view
/// can show transient feedback (success/failure) without affecting list rendering.
struct PostListView: View {
    // In production code, you may prefer injecting this from above (App/Coordinator) to avoid
    // constructing concrete services directly inside the view.
    @StateObject var vm = PostViewModel(service: ProductNetwork())
    @State var mutationErrorMessage = ""
    
    var body: some View {
        NavigationView {
            Group {
                switch vm.loadingState {
                case .idle, .loading:
                    ProgressView()
                case .empty:
                    Text("No post to display")
                case .error(let errorMessage):
                    Text(errorMessage)
                case .loaded(let posts):
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            ForEach(posts) { post in
                                Text(post.title)
                            }
                        }
                        .padding()
                    }
                }
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
        
        // In a real app, you'd typically observe `vm.mutatingState` and present an alert/toast.
        // Here we read it immediately after the mutation and reset it back to `.idle`.
        switch vm.mutatingState {
        case .success(let operation):
            if operation == .create {
                // Hook for post-create side effects (dismiss sheet, analytics, etc.)
            }
            vm.resetMutationState()
        case .failed( _, let errorMessage):
            mutationErrorMessage = errorMessage
        default:
            break
        }
        vm.resetMutationState()
    }
    
    /// Demo update call. (Not currently wired into the UI.)
    func update(_ id: Int) async {
        let updatedPost = UpdatePost(title: "Upated post", body: "New bddy")
        await vm.update(id, payload: updatedPost)
        
        switch vm.mutatingState {
        case .success(let operation):
            if operation == .update {
                // Hook for post-update side effects.
            }
            vm.resetMutationState()
        case .failed( _, let errorMessage):
            mutationErrorMessage = errorMessage
        default:
            break
        }
        vm.resetMutationState()
    }
}

#Preview {
    PostListView()
}

//
//  MyViewModel.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI
import Combine

@MainActor
/// UI-facing state + intent handlers for the Posts feature.
///
/// Marked `@MainActor` so mutations to `@Published` properties are always performed on the main thread.
class PostViewModel: ObservableObject {
    /// Renderable list of posts consumed by SwiftUI views.
//    @Published var posts = [Post]()
    
    @Published var loadingState: LoadingState<[Post]> = .idle
    
    /// Service dependency (real network in app, mock in previews/tests).
    private var service: PostServiceProtocol
    
    /// Dependency injection keeps the view model decoupled from the concrete network layer.
    init(service: PostServiceProtocol) {
        self.service = service
    }
    
    /// Loads posts and publishes them for the UI.
    ///
    /// Errors are logged for debugging in this sample; a production app would typically surface an
    /// error state (alert/toast/retry) instead of only printing.
    func fetchPost() async {
        loadingState = .loading
        do {
            let posts = try await service.fetchPost()
            loadingState = posts.isEmpty ? .empty : .loaded(posts)
        } catch {
            loadingState = .error(error.localizedDescription)
            print("DEBUG: something went wrong: \(error)")
        }
    }
    
    /// Creates a new post and prepends it into the list so the UI updates immediately.
    func createPost(_ payload: CreatedPost) async {
        do {
            let newPost = try await service.post(payload)
            insertOrStart(newPost)
        } catch {
            print("DEBUG: something went wrong creating a post: \(error)")
        }
    }
    
    /// Updates a post both remotely and locally (in-place replacement by id).
    func update(_ id: Int, payload: UpdatePost) async {
        do {
            let updatedProduct = try await service.update(id, payload: payload)
            updatePostIfLoaded(updatedProduct)
        } catch {
            print("DEBUG: something went wrong creating a post: \(error)")
        }
    }
    
    /// Deletes a post remotely, then removes it from the local list to keep UI and server in sync.
    func delete(_ id: Int) async {
        do {
            try await service.delete(id)
            deleteIfLoaded(id)
        } catch {
            print("DEBUG: something went wrong deleting a post: \(error)")
        }
    }
    
    private func insertOrStart(_ post: Post) {
        switch loadingState {
        case .loaded(var posts):
            posts.insert(post, at: 0)
            loadingState = .loaded(posts)
        default:
            loadingState = .loaded([post])
        }
    }
    
    private func updatePostIfLoaded(_ post: Post) {
        guard case .loaded(var posts) = loadingState else {
            return
        }
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        posts[index] = post
        loadingState = .loaded(posts)
    }
    
    private func deleteIfLoaded(_ id: Int) {
        guard case .loaded(var posts) = loadingState else {
            return
        }
        guard let index = posts.firstIndex(where: { $0.id == id }) else { return }
        posts.remove(at: index)
        loadingState = .loaded(posts)
    }
}

/// Represents which user intent is being performed (create vs update).
///
/// Useful when presenting the same form UI for multiple actions with different titles/buttons.
enum Intent {
    case create
    case update(Post)
    
    var navigationTitle: String {
        switch self {
        case .create:
            return "Create"
        case .update(let post):
            return "Update \(post)"
        }
    }
    
    var submitTitle: String {
        switch self {
        case .create:
            return "Create"
        case .update(let post):
            return "Update \(post)"
        }
    }
}

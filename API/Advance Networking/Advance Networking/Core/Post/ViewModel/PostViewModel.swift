//
//  PostViewModel.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI
import Combine

/// UI-facing state + intent handlers for the Posts feature.
///
/// `loadingState` is the single source of truth for the screen rendering:
/// - set to `.loading` when a request starts
/// - set to `.loaded([Post])` / `.empty` on success
/// - set to `.error(message)` on failure
///
/// `mutatingState` tracks write operations (create/update/delete) so the UI can show transient
/// side-effects (disable controls, show alerts/toasts) without disturbing the list rendering state.
///
/// Marked `@MainActor` so mutations to `@Published` properties are always performed on the main thread.
@MainActor
class PostViewModel: ObservableObject {
    /// Publishes screen state so SwiftUI can re-render automatically.
    @Published var loadingState: LoadingState<[Post]> = .idle
    
    /// Tracks create/update/delete progress + result for transient UI.
    ///
    /// The view typically resets this back to `.idle` after it consumes a success/failure event.
    @Published var mutatingState: MutationState = .idle
    
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
        }
    }
    
    /// Creates a new post and prepends it into the list so the UI updates immediately.
    func createPost(_ payload: CreatedPost) async {
        mutatingState = .inProgress(.create)
        do {
            let newPost = try await service.post(payload)
            insertOrStart(newPost)
            mutatingState = .success(.create)
        } catch {
            mutatingState = .failed(.create, error.localizedDescription)
        }
    }
    
    /// Updates a post both remotely and locally (in-place replacement by id).
    func update(_ id: Int, payload: UpdatePost) async {
        mutatingState = .inProgress(.update)
        do {
            let updatedProduct = try await service.update(id, payload: payload)
            updateItemIfLoaded(updatedProduct)
            mutatingState = .success(.update)
        } catch {
            mutatingState = .failed(.update, error.localizedDescription)
        }
    }
    
    /// Deletes a post remotely, then removes it from the local list to keep UI and server in sync.
    func delete(_ id: Int) async {
        mutatingState = .inProgress(.delete)
        do {
            try await service.delete(id)
            deleteIfLoaded(id)
            mutatingState = .success(.delete)
        } catch {
            mutatingState = .failed(.delete, error.localizedDescription)
        }
    }
    
    /// Resets `mutatingState` back to `.idle` after the UI consumes it.
    func resetMutationState() {
        mutatingState = .idle
    }
}

/// Reuses shared list-mutation helpers (`insertOrStart`, `updateItemIfLoaded`, `deleteIfLoaded`)
/// so the UI can update immediately after create/update/delete without a full refetch.
extension PostViewModel: @MainActor ListMutatingProtocol { }

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

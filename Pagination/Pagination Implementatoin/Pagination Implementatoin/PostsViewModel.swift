import Foundation
import Combine

@MainActor
final class PostsViewModel: ObservableObject {
    // Single source of truth for pagination:
    // offset/page-number pagination (a.k.a. `limit` + `page`) + loading/error flags.
    @Published private var state: PaginationState<Post>
    
    private let service: PostsServicing
    
    var posts: [Post] { state.items }
    var isLoadingInitial: Bool { state.isLoadingInitial }
    var isLoadingMore: Bool { state.isLoadingMore }
    var hasMore: Bool { state.hasMore }
    var errorMessage: String? {
        get { state.errorMessage }
        set { state.errorMessage = newValue }
    }
    
    init(service: PostsServicing, pageSize: Int = 20) {
        self.service = service
        self.state = PaginationState(pageSize: pageSize)
    }
    
    func loadInitial() async {
        // Avoid re-fetching on view re-appear. Pull-to-refresh is handled separately.
        guard posts.isEmpty else { return }
        await refresh()
    }
    
    func refresh() async {
        // A refresh resets paging to the first page.
        state.resetForRefresh()
        state.beginInitialLoad()
        defer { state.endInitialLoad() }
        
        do {
            let newPosts = try await service.fetchPosts(page: state.page, limit: state.pageSize)
            state.replaceItems(newPosts)
        } catch {
            state.errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
    
    func loadMoreIfNeeded(currentPost: Post) async {
        // "Infinite scroll" trigger:
        // When the *last* rendered row appears, ask for the next page.
        // Using the last row avoids prefetching too early and keeps the logic simple.
        guard let last = posts.last else { return }
        guard last.id == currentPost.id else { return }
        await loadMore()
    }
    
    func loadMore() async {
        // Defensive gates prevent duplicate concurrent page loads caused by repeated onAppear calls.
        guard state.hasMore, !state.isLoadingInitial, !state.isLoadingMore else { return }
        
        state.errorMessage = nil
        state.beginLoadMore()
        defer { state.endLoadMore() }
        
        do {
            let newPosts = try await service.fetchPosts(page: state.page, limit: state.pageSize)
            state.appendItems(newPosts)
        } catch {
            state.errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
    
    func retry() async {
        // Retry behavior depends on whether the list already has content.
        if posts.isEmpty {
            await refresh()
        } else {
            await loadMore()
        }
    }
}


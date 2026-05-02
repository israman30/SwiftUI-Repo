import Foundation
import Combine

@MainActor
final class PostsViewModel: ObservableObject {
    // Paging state lives in the view model so the view stays declarative:
    // - `page` tracks what to request next
    // - `pageSize` controls batch size
    // - `hasMore` prevents useless requests once the server returns a short page
    @Published private(set) var posts: [Post] = []
    @Published private(set) var isLoadingInitial = false
    @Published private(set) var isLoadingMore = false
    @Published var errorMessage: String?
    @Published private(set) var hasMore = true
    
    private let service: PostsServicing
    private let pageSize: Int
    /// The next page to request (1-based).
    private var page = 1
    
    init(service: PostsServicing, pageSize: Int = 20) {
        self.service = service
        self.pageSize = pageSize
    }
    
    func loadInitial() async {
        // Avoid re-fetching on view re-appear. Pull-to-refresh is handled separately.
        guard posts.isEmpty else { return }
        await refresh()
    }
    
    func refresh() async {
        // A refresh resets paging to the first page.
        page = 1
        hasMore = true
        errorMessage = nil
        isLoadingInitial = true
        
        defer { isLoadingInitial = false }
        
        do {
            let newPosts = try await service.fetchPosts(page: page, limit: pageSize)
            posts = newPosts
            // If the server returns fewer than `pageSize` items, we assume we've hit the end.
            hasMore = newPosts.count == pageSize
            page = 2
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
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
        guard hasMore, !isLoadingInitial, !isLoadingMore else { return }
        
        errorMessage = nil
        isLoadingMore = true
        defer { isLoadingMore = false }
        
        do {
            let newPosts = try await service.fetchPosts(page: page, limit: pageSize)
            posts.append(contentsOf: newPosts)
            
            if newPosts.count < pageSize {
                hasMore = false
            } else {
                page += 1
            }
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
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


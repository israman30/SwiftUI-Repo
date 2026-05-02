import Foundation

/// Pagination state model for offset/page-number pagination (`limit` + `page`).
///
/// This is intentionally UI-agnostic: it holds the "what page are we on?" + loading/error flags,
/// while the view model decides *when* to call the service and *how* to render the UI.
struct PaginationState<Item> {
    private(set) var items: [Item] = []
    private(set) var page: Int = 1
    let pageSize: Int
    
    private(set) var hasMore: Bool = true
    private(set) var isLoadingInitial: Bool = false
    private(set) var isLoadingMore: Bool = false
    var errorMessage: String?
    
    init(pageSize: Int) {
        self.pageSize = pageSize
    }
    
    mutating func resetForRefresh() {
        page = 1
        hasMore = true
        errorMessage = nil
    }
    
    mutating func beginInitialLoad() {
        isLoadingInitial = true
        isLoadingMore = false
    }
    
    mutating func endInitialLoad() {
        isLoadingInitial = false
    }
    
    mutating func beginLoadMore() {
        isLoadingMore = true
    }
    
    mutating func endLoadMore() {
        isLoadingMore = false
    }
    
    mutating func replaceItems(_ newItems: [Item]) {
        items = newItems
        updatePaging(afterReceiving: newItems)
    }
    
    mutating func appendItems(_ newItems: [Item]) {
        items.append(contentsOf: newItems)
        updatePaging(afterReceiving: newItems)
    }
    
    private mutating func updatePaging(afterReceiving newItems: [Item]) {
        // Offset/page-number pagination heuristic:
        // a "short page" means we reached the end.
        hasMore = newItems.count == pageSize
        if hasMore {
            page += 1
        }
    }
}


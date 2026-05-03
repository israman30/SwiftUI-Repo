//
//  ViewModel.swift
//  Pagination Simple Sample
//
//  Created by Israel Manzo on 5/3/26.
//

import SwiftUI
import Combine

/// View model driving an infinite-scrolling list of `User`s.
///
/// `@MainActor` ensures `@Published` updates are applied on the UI thread, even though networking is async.
@MainActor
class ViewModel: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published var isLoding: Bool = false
    @Published var errorMessage: String? = nil
    @Published var hasMorePges: Bool = true
    
    // Dependencies
    private let services: NetworkServices
    private var pagination = PaginationState()
    
    init(_ services: NetworkServices) {
        self.services = services
    }
    
    /// Clears existing results and fetches the first page.
    ///
    /// Called on initial appearance and on pull-to-refresh.
    func loadInitial() async {
        pagination.reset()
        users = []
        hasMorePges = true
        errorMessage = nil
        await fetchNextPage()
    }
    
    /// Triggers the next page when the current row is close to the bottom.
    ///
    /// This is invoked from each row's `.task`; `PaginationState.isLoeading` prevents overlap.
    func loadNextPageIfNeeded(currentItem: User) async {
        guard shouldLoadMore(currentItem) else { return }
        await fetchNextPage()
    }
    
    /// Fetches the next page using the current pagination offset.
    private func fetchNextPage() async {
        guard !pagination.isLoeading, pagination.hasMorePages else { return }
        
        pagination.isLoeading = true
        
        // Only show the full-screen loader for the very first page.
        isLoding = users.isEmpty
        errorMessage = nil
        
        defer {
            pagination.isLoeading = false
            isLoding = false
        }
        do {
            let result = try await services.fetchUser(limit: pagination.pageSize, offset: pagination.offSet)
            
            // Append to preserve already-loaded rows.
            users.append(contentsOf: result.item)
            pagination.hasMorePages = result.hasMore
            pagination.totalItems = result.total
            pagination.nextPage()
            hasMorePges = result.hasMore
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// Returns `true` when the user has scrolled near the bottom of the list.
    ///
    /// We start prefetching when the visible row is within the last ~3 items to make pagination feel seamless.
    private func shouldLoadMore(_ item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        let thresholdIndex = max(0, users.count - 3)
        let itemIndex = users.firstIndex(where: { $0.id == item.id }) ?? 0
        return itemIndex >= thresholdIndex && lastItem.id == users.last?.id && hasMorePges
    }
    
}

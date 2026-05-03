//
//  ViewModel.swift
//  Pagination Simple Sample
//
//  Created by Israel Manzo on 5/3/26.
//

import SwiftUI
import Combine

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
    
    func loadInitial() async {
        pagination.reset()
        users = []
        hasMorePges = true
        errorMessage = nil
        await fetchNextPage()
    }
    
    func loadNextPageIfNeeded(currentItem: User) async {
        guard shouldLoadMore(currentItem) else { return }
        await fetchNextPage()
    }
    
    private func fetchNextPage() async {
        guard !pagination.isLoeading, pagination.hasMorePages else { return }
        
        pagination.isLoeading = true
        
        isLoding = users.isEmpty
        errorMessage = nil
        
        defer {
            pagination.isLoeading = false
            isLoding = false
        }
        do {
            let result = try await services.fetchUser(limit: pagination.pageSize, offset: pagination.offSet)
            
            users.append(contentsOf: result.item)
            pagination.hasMorePages = result.hasMore
            pagination.totalItems = result.total
            pagination.nextPage()
            hasMorePges = result.hasMore
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func shouldLoadMore(_ item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        let thresholdIndex = max(0, users.count - 3)
        let itemIndex = users.firstIndex(where: { $0.id == item.id }) ?? 0
        return itemIndex >= thresholdIndex && lastItem.id == users.last?.id && hasMorePges
    }
    
}

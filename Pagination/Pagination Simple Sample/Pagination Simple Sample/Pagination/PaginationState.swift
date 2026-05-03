//
//  PaginationState.swift
//  Pagination Simple Sample
//
//  Created by Israel Manzo on 5/2/26.
//

import Foundation

/// Lightweight pagination bookkeeping for offset-based APIs.
///
/// This type intentionally does not perform networking. It only tracks:
/// - which "page" we are on (used to compute the next `offset`)
/// - whether a request is currently in-flight (`isLoeading`)
/// - whether the server indicates more pages exist (`hasMorePages`)
///
/// The view model is responsible for updating these values based on responses/errors.
struct PaginationState {
    /// Zero-based page index. Page 0 corresponds to `offset == 0`.
    var currentPage: Int = 0
    /// Number of items to request per page.
    var pageSize: Int = 10
    /// Used to prevent overlapping requests (e.g. multiple row `.task` triggers).
    var isLoeading: Bool = false
    /// When false, pagination stops requesting more pages.
    var hasMorePages: Bool = true
    /// Total number of items available (if the API provides it).
    var totalItems: Int = 0
    
    /// Offset for the next request, derived from `currentPage` and `pageSize`.
    var offSet: Int {
        currentPage * pageSize
    }
    
    /// Advances to the next page so that the subsequent request uses the next `offset`.
    mutating func nextPage() {
        currentPage += 1
    }
    
    /// Resets all pagination state for a fresh initial load.
    mutating func reset() {
        currentPage = 0
        isLoeading = false
        hasMorePages = true
        totalItems = 0
    }
}

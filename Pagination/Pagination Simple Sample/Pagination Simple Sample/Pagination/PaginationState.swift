//
//  PaginationState.swift
//  Pagination Simple Sample
//
//  Created by Israel Manzo on 5/2/26.
//

import Foundation

struct PaginationState {
    var currentPage: Int = 0
    var pageSize: Int = 10
    var isLoeading: Bool = false
    var hasMorePages: Bool = true
    var totalItems: Int = 0
    
    var offSet: Int {
        currentPage * pageSize
    }
    
    mutating func nextPage() {
        currentPage += 1
    }
    
    mutating func reset() {
        currentPage = 0
        isLoeading = false
        hasMorePages = true
        totalItems = 0
    }
}

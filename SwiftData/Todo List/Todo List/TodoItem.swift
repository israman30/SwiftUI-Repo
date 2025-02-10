//
//  TodoItem.swift
//  Todo List
//
//  Created by Israel Manzo on 2/9/25.
//

import Foundation
import SwiftData

@Model 
class TodoItem {
    var title: String
    var timestamp: Date
    var isCompleted: Bool
    
    init(title: String, timestamp: Date = Date(), isCompleted: Bool = false) {
        self.title = title
        self.timestamp = timestamp
        self.isCompleted = isCompleted
    }
}

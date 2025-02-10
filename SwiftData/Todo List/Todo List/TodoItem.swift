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
    var isImportant: Bool 
    
    init(title: String = "", timestamp: Date = .now, isCompleted: Bool = false, isImportant: Bool = false) {
        self.title = title
        self.timestamp = timestamp
        self.isCompleted = isCompleted
        self.isImportant = isImportant
    }
}

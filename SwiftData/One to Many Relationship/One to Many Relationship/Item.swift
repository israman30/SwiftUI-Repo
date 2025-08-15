//
//  Item.swift
//  One to Many Relationship
//
//  Created by Israel Manzo on 8/14/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

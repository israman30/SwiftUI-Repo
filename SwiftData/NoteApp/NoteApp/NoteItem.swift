//
//  Note.swift
//  NoteApp
//
//  Created by Israel Manzo on 2/10/25.
//

import Foundation
import SwiftData

@Model
class NoteItem: Identifiable {
    var title: String
    var content: String
    var isCompleted: Bool
    
    init(title: String, content: String, isCompleted: Bool) {
        self.title = title
        self.content = content
        self.isCompleted = isCompleted
    }
}

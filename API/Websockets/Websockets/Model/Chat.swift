//
//  Chat.swift
//  Websockets
//
//  Created by Israel Manzo on 5/4/26.
//

import Foundation

enum ChatSender: Hashable {
    case me
    case bot
}

struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    let text: String
    let sender: ChatSender
    let sentAt: Date
    
    init(id: UUID = UUID(), text: String, sender: ChatSender, sentAt: Date = Date()) {
        self.id = id
        self.text = text
        self.sender = sender
        self.sentAt = sentAt
    }
}

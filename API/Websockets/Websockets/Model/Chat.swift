//
//  Chat.swift
//  Websockets
//
//  Created by Israel Manzo on 5/4/26.
//

import Foundation

struct TokenManager {
    static let shared = TokenManager()
    var currentId = ""
    var currentUserEmail = ""
    var accessToken = ""
    var bearerHeader = ""
    var currentUserId = ""
}

enum MessageStatus: String, Codable {
    case sending
    case sent
    case delivered
    case failed
}

enum MessageType: String, Codable {
    case text
    case image
    case typing
    case system
}

struct ChatMessage: Codable, Identifiable, Equatable {
    let id: String
    let senderId: String
    let senderName: String
    let content: String
    let type: MessageType
    let timestamp: Date
    var status: MessageStatus
    
    var isFromCurrentUser: Bool {
        false
    }
    
    static func outgoing(content: String, type: MessageType = .text) -> ChatMessage {
        ChatMessage(
            id: UUID().uuidString,
            senderId: TokenManager.shared.currentId,
            senderName: TokenManager.shared.currentUserEmail,
            content: content,
            type: type,
            timestamp: Date(),
            status: .sending
        )
    }
}

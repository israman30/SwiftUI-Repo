//
//  Websocket.swift
//  Websockets
//
//  Created by Israel Manzo on 5/4/26.
//

import SwiftUI

enum WebsocketEvent: Codable {
    case message(ChatMessage)
    case typing(userId: String, isTyping: Bool)
    case userJoined(userId: String, name: String)
    case userLeft(userId: String)
    case error(String)
    case ping
    
    enum CodingKeys: String, CodingKey {
        case type, payload
    }
    
    enum EventType: String, Codable {
        case message
        case typing
        case userJoined  = "user_joined"
        case userLeft    = "user_left"
        case error
        case ping
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(EventType.self, forKey: .type)
        
        switch type {
        case .message:
            let msg = try container.decode(ChatMessage.self, forKey: .payload)
            self = .message(msg)
        case .typing:
            let payload = try container.decode(TypingPayload.self, forKey: .payload)
            self = .typing(userId: payload.userId, isTyping: payload.isTyping)
        case .userJoined:
            let payload = try container.decode(UserPayload.self, forKey: .payload)
            self = .userJoined(userId: payload.userId, name: payload.name)
        case .userLeft:
            let payload = try container.decode(UserPayload.self, forKey: .payload)
            self = .userLeft(userId: payload.userId)
        case .error:
            let payload = try container.decode(ErrorPayload.self, forKey: .payload)
            self = .error(payload.message)
        case .ping:
            self = .ping
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .message(let msg):
            try container.encode(EventType.message, forKey: .type)
            try container.encode(msg, forKey: .payload)
        case .typing(let userId, let isTyping):
            try container.encode(EventType.typing, forKey: .type)
            try container.encode(TypingPayload(userId: userId, isTyping: isTyping), forKey: .payload)
        default: break
        }
    }
}

private struct TypingPayload: Codable {
    let userId: String
    let isTyping: Bool
}

private struct UserPayload: Codable {
    let userId: String
    let name: String
}

private struct ErrorPayload: Codable {
    let message: String
}

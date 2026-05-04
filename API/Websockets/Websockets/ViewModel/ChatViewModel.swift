//
//  ChatViewModel.swift
//  Websockets
//
//  Created by Israel Manzo on 5/4/26.
//

import SwiftUI
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var draft: String = ""
    @Published private(set) var messages: [ChatMessage] = [
        ChatMessage(text: "Hey! Type a message below.", sender: .bot)
    ]
    
    func sendDraft() {
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        draft = ""
        messages.append(ChatMessage(text: trimmed, sender: .me))
        
        Task { [weak self] in
            try? await Task.sleep(nanoseconds: 650_000_000)
            self?.receive(text: "Echo: \(trimmed)")
        }
    }
    
    private func receive(text: String) {
        messages.append(ChatMessage(text: text, sender: .bot))
    }
}

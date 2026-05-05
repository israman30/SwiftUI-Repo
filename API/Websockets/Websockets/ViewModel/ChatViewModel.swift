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
    @Published private(set) var messages: [ChatMessage] = []
    @Published private(set) var connectionState: ConnectionState = .disconnected
    @Published private(set) var typingUsers: Set<String> = []
    @Published private(set) var onlineUsers: [String] = []
    @Published var inputText: String = ""
    @Published var errorMessage: String?
    
    var isConnected: Bool {
        connectionState == .connected
    }
    
    var typingIndicator: String? {
        switch typingUsers.count {
        case 0:
            return nil
        case 1:
            return "\(typingUsers.first!) is typing..."
        case 2:
            return "\(typingUsers.count) people are typing..."
        default:
            return nil
        }
    }
    
    private let service: WebSocketServiceProtocol
    private let roomId: String
    private var cancellables = Set<AnyCancellable>()
    private var typingTask: Task<Void, Never>?
    private var isTyping = false
    
    init(roomId: String, service: WebSocketServiceProtocol) {
        self.roomId = roomId
        self.service = service
        bindService()
    }
    
    func onAppear() async {
        await service.connect(roomId: roomId)
    }
    
    func onDisappear() async {
        service.disconnect()
        stopTypingIndicator()
    }
    
    func sendMessage() async {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, isConnected else { return }
        
        let message = ChatMessage.outgoing(content: text)
        
        appendOrUpdate(message)
        inputText = ""
        
        stopTypingIndicator()
        
        do {
            try await service.send(event: .message(message))
            updateStatus(of: message.id, to: .sent)
        } catch {
            updateStatus(of: message.id, to: .failed)
            errorMessage = error.localizedDescription
        }
    }
    
    func handleTyping() {
        guard isConnected else { return }
        
        if !isTyping {
            isTyping = true
            sendTypingEvent(isTyping: true)
        }
        
        typingTask?.cancel()
        typingTask = Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            if !Task.isCancelled {
                stopTypingIndicator()
            }
        }
    }
    
    func stopTypingIndicator() {
        guard isTyping else { return }
        isTyping = false
        sendTypingEvent(isTyping: false)
        typingTask?.cancel()
    }
    
    func retry(message: ChatMessage) async {
        updateStatus(of: message.id, to: .sending)
        do {
            try await service.send(event: .message(message))
            updateStatus(of: message.id, to: .sent)
        } catch {
            updateStatus(of: message.id, to: .failed)
        }
    }
    
    func bindService() {
        service.connectionState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.connectionState = state
                if case .failed(let error) = state {
                    self?.errorMessage = error
                }
            }.store(in: &cancellables)
        
        service.receivedEvents
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                 self?.handleEvent(event)
            }
            .store(in: &cancellables)

    }
    
    private func handleEvent(_ event: WebsocketEvent) {
        switch event {
        case .message(let chatMessage):
            appendOrUpdate(chatMessage)
        case .typing(let userId, let isTyping):
            if isTyping {
                typingUsers.insert(userId)
            } else {
                typingUsers.remove(userId)
            }
        case .userJoined(let userId, let name):
            onlineUsers.append(userId)
        case .userLeft(let userId):
            onlineUsers.removeAll(where: { $0 == userId })
            typingUsers.remove(userId)
        case .error(let string):
            errorMessage = string
        case .ping:
            break
        }
    }
    
    private func appendOrUpdate(_ message: ChatMessage) {
        if let index = messages.firstIndex(where: { $0.id == message.id }) {
            messages[index] = message
        } else {
            messages.append(message)
        }
    }
    
    private func updateStatus(of id: String, to status: MessageStatus) {
        guard let index = messages.firstIndex(where: { $0.id == id }) else { return }
        messages[index].status = status
    }
    
    private func sendTypingEvent(isTyping: Bool) {
        let userId = TokenManager.shared.currentUserId
        Task {
            try? await service.send(event: .typing(userId: userId, isTyping: isTyping))
        }
    }
}

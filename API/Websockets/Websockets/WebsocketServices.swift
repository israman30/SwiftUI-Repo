//
//  WebsocketServices.swift
//  Websockets
//
//  Created by Israel Manzo on 5/4/26.
//

import Foundation
import Combine

enum WebSocketError: LocalizedError {
    case notConnected
    case connectionClosed
    case encodingFailed

    var errorDescription: String? {
        switch self {
        case .notConnected:     return "WebSocket is not connected"
        case .connectionClosed: return "WebSocket connection was closed"
        case .encodingFailed:   return "Failed to encode message"
        }
    }
}

enum ConnectionState: Equatable {
    case disconnected
    case connecting
    case connected
    case reconnecting(attempt: Int)
    case failed(String)
}

protocol WebSocketServiceProtocol {
    var connectionState: AnyPublisher<ConnectionState, Never> { get }
    var receivedEvents: AnyPublisher<WebsocketEvent, Never> { get }
    func connect(roomId: String) async
    func disconnect()
    func send(event: WebsocketEvent) async throws
}

final class LegacyWebSocketService: NSObject, WebSocketServiceProtocol, URLSessionDelegate {
    func disconnect() {
        isIntentionalDisconnect = true
        stopTasks()
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        connectionStateSubject.send(.disconnected)
//        logger.log(level: .warning, message: "WebSocket disconnected intentionally")
    }
    
    private let connectionStateSubject = CurrentValueSubject<ConnectionState, Never>(.disconnected)
    private let receivedEventsSubject  = PassthroughSubject<WebsocketEvent, Never>()
    
    var connectionState: AnyPublisher<ConnectionState, Never> {
        connectionStateSubject.eraseToAnyPublisher()
    }
    
    var receivedEvents: AnyPublisher<WebsocketEvent, Never> {
        receivedEventsSubject.eraseToAnyPublisher()
    }
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    private var currentRoomId: String?
    private var reconnectAttempts = 0
    private var pingTask: Task<Void, Never>?
    private var receiveTask: Task<Void, Never>?
    private var isIntentionalDisconnect = false
    
    private let maxReconnectAttempts = 5
//    private let logger = NetworkLogger.shared
    
    func connect(roomId: String) async {
        currentRoomId = roomId
        isIntentionalDisconnect = false
        await establishConnection(roomId: roomId)
    }
    
    func send(event: WebsocketEvent) async throws {
        guard connectionStateSubject.value == .connected else {
            throw WebSocketError.notConnected
        }
        
        let data = try JSONEncoder().encode(event)
        let message = URLSessionWebSocketTask.Message.data(data)
        
        try await webSocketTask?.send(message)
//        logger.log(level: .request, message: "WebSocket sent → \(event)")
    }
    
    private func establishConnection(roomId: String) async {
        connectionStateSubject.send(.connecting)
        
        guard var components = URLComponents(string: "constants.wsEndpoint") else {
            connectionStateSubject.send(.failed("Invalid WebSocket URL"))
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "roomId", value: roomId),
            URLQueryItem(name: "token",  value: TokenManager.shared.accessToken)
        ]
        
        guard let url = components.url else { return }
        
        var request = URLRequest(url: url)
        request.setValue(TokenManager.shared.bearerHeader, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10
        
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        webSocketTask = urlSession?.webSocketTask(with: request)
        webSocketTask?.resume()
        
//        logger.log(level: .request, message: "WebSocket connecting → \(url.absoluteString)")
        
        startReceiving()
        startPingPong()
    }
    
    private func startReceiving() {
        receiveTask = Task { [weak self] in
            guard let self else { return }
            
            while !Task.isCancelled {
                do {
                    guard let task = webSocketTask else { break }
                    let message = try await task.receive()
                    
                    switch message {
                    case .data(let data):
                        handleIncoming(data: data)
                    case .string(let string):
                        if let data = string.data(using: .utf8) {
                            handleIncoming(data: data)
                        }
                    @unknown default:
                        break
                    }
                    
                } catch {
                    if !isIntentionalDisconnect {
                        await handleConnectionLoss(error: error)
                    }
                    break
                }
            }
        }
    }
    
    private func handleIncoming(data: Data) {
        do {
            let event = try JSONDecoder().decode(WebsocketEvent.self, from: data)
//            logger.log(level: .response, message: "WebSocket received → \(event)")
            
            if case .ping = event {
                Task { try? await send(event: .ping) }
                return
            }
            
            receivedEventsSubject.send(event)
            
        } catch {
//            logger.logError(error, url: nil)
        }
    }
    
    private func startPingPong() {
        pingTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 30_000_000_000) // 30 seconds
                self?.webSocketTask?.sendPing { error in
                    if let error {
//                        self?.logger.logError(error, url: nil)
                    }
                }
            }
        }
    }
    
    private func handleConnectionLoss(error: Error) async {
        guard !isIntentionalDisconnect,
              reconnectAttempts < maxReconnectAttempts,
              let roomId = currentRoomId else {
            connectionStateSubject.send(.failed(error.localizedDescription))
            return
        }
        
        reconnectAttempts += 1
        let delay = Double(reconnectAttempts) * 2.0  // exponential back-off
        
        connectionStateSubject.send(.reconnecting(attempt: reconnectAttempts))
//        logger.log(level: .warning, message: "WebSocket reconnecting (attempt \(reconnectAttempts)) in \(delay)s")
        
        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        await establishConnection(roomId: roomId)
    }
    
    private func stopTasks() {
        pingTask?.cancel()
        receiveTask?.cancel()
        pingTask = nil
        receiveTask = nil
    }
}

extension LegacyWebSocketService: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?) {
        reconnectAttempts = 0
        connectionStateSubject.send(.connected)
//        logger.log(level: .success, message: "WebSocket connected")
    }

    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        let reasonStr = reason.flatMap { String(data: $0, encoding: .utf8) } ?? "none"
//        logger.log(level: .warning, message: "WebSocket closed → code: \(closeCode) reason: \(reasonStr)")

        if !isIntentionalDisconnect {
            Task { await handleConnectionLoss(error: WebSocketError.connectionClosed) }
        }
    }
}

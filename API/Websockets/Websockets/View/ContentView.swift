//
//  ContentView.swift
//  Websockets
//
//  Created by Israel Manzo on 5/4/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
        NavigationStack {
            ChatView(roomId: viewModel)
                .navigationTitle("Chat")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
 User types message
         ↓
 ChatViewModel.handleTyping()
 → sends typing event via WebSocketService

 User taps Send
         ↓
 ChatViewModel.sendMessage()
 → Optimistic UI append (status: .sending)
 → WebSocketService.send(.message)
 → Success → status: .sent
 → Failure → status: .failed + retry button

 Server pushes message
         ↓
 WebSocketService receive loop
 → Decode WebSocketEvent
 → Publish via receivedEventsSubject
 → ChatViewModel.handleEvent()
 → appendOrUpdate messages array
 → SwiftUI re-renders MessageBubble

 Connection drops
         ↓
 URLSessionWebSocketDelegate.didCloseWith
 → Exponential backoff reconnect
 → connectionState → .reconnecting(attempt: N)
 → Banner shows in ChatView
 → On success → .connected → banner hides
 */

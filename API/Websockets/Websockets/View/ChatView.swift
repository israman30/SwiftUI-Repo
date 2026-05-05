//
//  ChatView.swift
//  Websockets
//
//  Created by Israel Manzo on 5/4/26.
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    @FocusState private var isInputFocused: Bool
    @Namespace private var scrollSpace
    
    init(roomId: String) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(roomId: roomId, service: LegacyWebSocketService()))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            connectionBanner
            messageList
            typingIndicator
            inputBar
        }
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { statusToolbarItem }
        .task {
            await viewModel.onAppear()
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    @ViewBuilder
    private var connectionBanner: some View {
        switch viewModel.connectionState {
        case .disconnected:
            bannerView(text: "Disconnected", color: .gray)
        case .connecting:
            bannerView(text: "Connecting...", color: .orange)
        case .connected:
            EmptyView()
        case .reconnecting(let attempt):
            bannerView(text: "Reconnecting... (attempt \(attempt))", color: .orange)
        case .failed(let string):
            bannerView(text: "Connection failed. Check your network.", color: .red)
        }
    }
    
    private func bannerView(text: String, color: Color) -> some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(color)
            .transition(.move(edge: .top).combined(with: .opacity))
    }
    
    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(viewModel.messages) { message in
                        MessageBubble(message: message) {
                            Task { await viewModel.retry(message: message) }
                        }
                        .id(message.id)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            .onChange(of: viewModel.messages.count) { oldValue, newValue in
                withAnimation {
                    proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                }
            }
        }
    }
    
    @ViewBuilder
    private var typingIndicator: some View {
        if let text = viewModel.typingIndicator {
            HStack {
                Text(text)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
    
    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Message...", text: $viewModel.inputText, axis: .vertical)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .focused($isInputFocused)
                .lineLimit(1...5)
                .onChange(of: viewModel.inputText) { _, _ in
                    viewModel.handleTyping()
                }
            
            Button {
                Task {
                    await viewModel.sendMessage()
                    isInputFocused = false
                }
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(
                        viewModel.inputText.isEmpty || !viewModel.isConnected
                        ? Color.gray
                        : Color.blue
                    )
            }
            .disabled(viewModel.inputText.isEmpty || !viewModel.isConnected)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.bar)
    }
    
    private var statusToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            HStack(spacing: 4) {
                Circle()
                    .fill(viewModel.isConnected ? Color.green : Color.red)
                    .frame(width: 8, height: 8)
                Text(viewModel.isConnected ? "Online" : "Offline")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    let onRetry: () -> Void
    
    var body: some View {
        HStack {
            HStack {
                if message.isFromCurrentUser {
                    Spacer(minLength: 60)
                }
                VStack(alignment: message.isFromCurrentUser ? .trailing : .leading, spacing: 3) {
                    if !message.isFromCurrentUser {
                        Text(message.senderName)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .padding(.leading, 4)
                    }
                    Text(message.content)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(message.isFromCurrentUser ? Color.blue : Color(.systemGray5))
                        .foregroundStyle(message.isFromCurrentUser ? .white : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                HStack(spacing: 4) {
                    Text(message.timestamp.formatted(.dateTime.hour().minute()))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    
                    // Status icon
                    if message.isFromCurrentUser {
                        statusIcon
                    }
                }
                .padding(.horizontal, 4)
            }
            if !message.isFromCurrentUser {
                Spacer(minLength: 60)
            }
        }
    }
    
    @ViewBuilder
    private var statusIcon: some View {
        switch message.status {
        case .sending:
            ProgressView().scaleEffect(0.5)
        case .sent:
            Image(systemName: "checkmark")
                .font(.caption2).foregroundStyle(.secondary)
        case .delivered:
            Image(systemName: "checkmark.circle")
                .font(.caption2).foregroundStyle(.secondary)
        case .failed:
            Button(action: onRetry) {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.caption2).foregroundStyle(.red)
            }
        }
    }
}

struct TypingDotsView: View {

    @State private var animate = false

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(Color.secondary)
                    .frame(width: 6, height: 6)
                    .scaleEffect(animate ? 1.2 : 0.8)
                    .animation(
                        .easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(Double(index) * 0.15),
                        value: animate
                    )
            }
        }
        .onAppear { animate = true }
    }
}


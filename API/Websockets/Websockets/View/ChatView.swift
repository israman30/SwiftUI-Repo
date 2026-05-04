//
//  ChatView.swift
//  Websockets
//
//  Created by Israel Manzo on 5/4/26.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            messagesList
            Divider()
            composer
        }
        .background(Color(.systemBackground))
    }
    
    private var messagesList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.messages) { message in
                        ChatBubble(message: message)
                            .id(message.id)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: viewModel.messages.count) { _, _ in
                guard let lastID = viewModel.messages.last?.id else { return }
                withAnimation(.easeOut(duration: 0.2)) {
                    proxy.scrollTo(lastID, anchor: .bottom)
                }
            }
            .onAppear {
                guard let lastID = viewModel.messages.last?.id else { return }
                proxy.scrollTo(lastID, anchor: .bottom)
            }
        }
    }
    
    private var composer: some View {
        HStack(spacing: 10) {
            TextField("Message…", text: $viewModel.draft, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(1...4)
                .focused($isInputFocused)
                .submitLabel(.send)
                .onSubmit {
                    viewModel.sendDraft()
                }
            
            Button {
                viewModel.sendDraft()
                isInputFocused = true
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(10)
                    .background(Circle().fill(Color.accentColor))
                    .foregroundStyle(.white)
            }
            .accessibilityLabel("Send message")
            .disabled(viewModel.draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(12)
        .background(.thinMaterial)
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.sender == .bot { bubble }
            Spacer(minLength: 30)
            if message.sender == .me { bubble }
        }
    }
    
    private var bubble: some View {
        Text(message.text)
            .font(.body)
            .foregroundStyle(message.sender == .me ? .white : .primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(message.sender == .me ? Color.accentColor : Color(.secondarySystemBackground))
            )
            .overlay(alignment: .bottomTrailing) {
                Text(message.sentAt, format: .dateTime.hour().minute())
                    .font(.caption2)
                    .foregroundStyle(message.sender == .me ? .white.opacity(0.8) : .secondary)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 6)
                    .opacity(0.85)
            }
            .frame(maxWidth: 280, alignment: message.sender == .me ? .trailing : .leading)
    }
}

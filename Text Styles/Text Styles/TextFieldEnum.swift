//
//  TextFieldEnum.swift
//  Text Styles
//
//  Created by Israel Manzo on 1/31/25.
//

import SwiftUI

enum InputState: Equatable {
    case idle
    case focused(InputValidity)
    case inactive(InputValidity)
    
    enum InputValidity: Equatable {
        case empty
        case valid
        case invalid(String)
    }
}

extension InputState {
    var tintColor: Color {
        switch self {
        case .idle:
            return .secondary
        case let .focused(validity):
            switch validity {
            case .empty, .valid:
                return .blue
            case .invalid:
                return .red
            }
        case let .inactive(validity):
            switch validity {
            case .empty:
                return .secondary
            case .valid:
                return .blue
            case .invalid:
                return .red
            }
        }
    }
}

struct InputConfiguration {
    let placeholder: String
}

struct TextFieldEnum: View {
    private let config: InputConfiguration
    @Binding private(set) var text: String
    @FocusState private var isFocused: Bool
    @State private var inputState: InputState = .idle
    
    init(config: InputConfiguration, text: Binding<String>) {
        self.config = config
        self._text = text
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            mainTextField
            floatingLabel
        }
        .frame(height: 55)
        .animation(.spring(duration: 0.2), value: inputState)
        .onChange(of: text) { _, _ in
            updateState()
        }
        .onChange(of: isFocused) { _, _ in
            updateState()
        }
    }
    
    private var mainTextField: some View {
        TextField("", text: $text)
            .focused($isFocused)
            .padding(.horizontal)
            .frame(height: 55)
            .background(
                Capsule()
                    .stroke(
                        inputState.tintColor,
                        lineWidth: isFocused ? 2 : 1
                    )
            )
    }
    
    private var floatingLabel: some View {
        Text(config.placeholder)
            .padding(.horizontal, 5)
            .background(.background)
            .foregroundStyle(inputState.tintColor)
            .padding(.leading)
            .offset(y: labelOffset)
            .scaleEffect(labelScale)
            .onTapGesture {
                isFocused = true
            }
    }
    
    private func updateState() {
        if isFocused {
            inputState = .focused(.empty)
        } else {
            inputState = text.isEmpty ? .idle : .inactive(.valid)
        }
    }
    
    private var labelOffset: CGFloat {
        switch inputState {
        case .idle where text.isEmpty:
            return 0
        default:
            return -32
        }
    }
    
    private var labelScale: CGFloat {
        switch inputState {
        case .idle where text.isEmpty:
            return 1
        default:
            return 0.85
        }
    }
}

#Preview {
    TextFieldEnum(config: InputConfiguration(placeholder: "placeholder"), text: .constant(""))
}

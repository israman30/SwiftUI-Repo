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
        Text("Hello, World!")
    }
}

#Preview {
    TextFieldEnum(config: InputConfiguration(placeholder: "placeholder"), text: .constant("text"))
}

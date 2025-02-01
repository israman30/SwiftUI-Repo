//
//  TextFieldEnum.swift
//  Text Styles
//
//  Created by Israel Manzo on 1/31/25.
//

import SwiftUI

enum InputState: Equatable {
    case idle
    case focused
    case inactive
    
    enum InputValidity {
        case empty
        case valid
        case invalid
    }
}

struct TextFieldEnum: View {
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    TextFieldEnum()
}

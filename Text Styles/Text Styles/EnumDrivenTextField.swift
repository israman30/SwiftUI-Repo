//
//  EnumDrivenTextField.swift
//  Text Styles
//
//  Created by Israel Manzo on 5/20/25.
//

import SwiftUI

enum InputValidationType {
    case required
    case email
    case phone
    case custom((String) -> ValidationResult)
}

enum ValidationResult {
    case valid
    case invalid(String)
}

struct EnumDrivenTextField: View {
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    EnumDrivenTextField()
}

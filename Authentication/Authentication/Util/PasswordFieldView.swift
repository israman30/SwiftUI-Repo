//
//  PasswordFieldView.swift
//  Authentication
//
//  Created by Israel Manzo on 3/28/24.
//

import SwiftUI

struct PasswordFieldView: View {
    @Binding var input: String
    var placeholder = "Password"
    
    var body: some View {
        SecureField(placeholder, text: $input)
            .textFieldStyle(CustomTextField())
            .textInputAutocapitalization(.never)
    }
}

#Preview {
    PasswordFieldView(input: .constant("xxxxxx"))
}

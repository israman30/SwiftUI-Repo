//
//  EmailFieldView.swift
//  Authentication
//
//  Created by Israel Manzo on 3/28/24.
//

import SwiftUI

struct EmailFieldView: View {
    
    @Binding var input: String
    var placeholder = "Email"
    
    var body: some View {
        TextField(placeholder, text: $input)
    }
}

#Preview {
    EmailFieldView(input: .constant("email@mail.com"))
}

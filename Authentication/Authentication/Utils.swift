//
//  Utils.swift
//  Authentication
//
//  Created by Israel Manzo on 3/28/24.
//

import SwiftUI

struct CustomTextField: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(.horizontal, 5)
            .padding(.vertical, 10)
            .clipShape(RoundedRectangle(cornerRadius: 5.0))
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.black, lineWidth: 1)
            }
    }
}

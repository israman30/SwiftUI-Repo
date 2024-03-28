//
//  LoginView.swift
//  Authentication
//
//  Created by Israel Manzo on 3/28/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(spacing: 20) {
            EmailFieldView(input: .constant("johndoe@mail.com"))
            PasswordFieldView(input: .constant("xxxxxxx"))
            
            Button("Submit") {
                
            }
            .buttonStyle(.borderedProminent)
            
            Button("Sign Up") {
                
            }
            .buttonStyle(.bordered)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    LoginView()
}

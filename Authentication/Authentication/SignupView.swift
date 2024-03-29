//
//  SignupView.swift
//  Authentication
//
//  Created by Israel Manzo on 3/28/24.
//

import SwiftUI

struct SignupView: View {
    var body: some View {
        VStack(spacing: 20) {
            EmailFieldView(input: .constant("johndoe@mail.com"))
            PasswordFieldView(input: .constant("xxxxxxx"))
            PasswordFieldView(input: .constant("xxxxxxx"), placeholder: "Confirm Password")
            
            Button("Sign Up") {
                
            }
            .buttonStyle(.borderedProminent)
            
            Button("Login") {
                
            }
            .buttonStyle(.bordered)
            
        }
        .padding(.horizontal, 20)
        .navigationTitle("Signup")
    }
}

#Preview {
    SignupView()
}

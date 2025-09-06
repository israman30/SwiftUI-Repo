//
//  LoginView.swift
//  API and Auth
//
//  Created by Israel Manzo on 9/5/25.
//

import SwiftUI

struct LoginView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            Button("Signup") {
                // event
            }
        }
    }
}

#Preview {
    LoginView()
}

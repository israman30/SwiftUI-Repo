//
//  LoginView.swift
//  Authentication
//
//  Created by Israel Manzo on 3/28/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var vm: ViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            EmailFieldView(input: $vm.email)
            PasswordFieldView(input: $vm.password)
            
            Button("Submit") {
                vm.loginTapped()
            }
            .buttonStyle(.borderedProminent)
            
            Button("Sign Up") {
                vm.signupTapped()
            }
            .buttonStyle(.bordered)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    LoginView(vm: .init())
}

//
//  SignupView.swift
//  Authentication
//
//  Created by Israel Manzo on 3/28/24.
//

import SwiftUI

struct SignupView: View {
    
    @StateObject var vm: ViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            EmailFieldView(input: $vm.email)
            PasswordFieldView(input: $vm.password)
            PasswordFieldView(input: $vm.confirmedPassword, placeholder: "Confirm Password")
            
            Button("Sign Up") {
                vm.signup()
            }
            .buttonStyle(.borderedProminent)
            
            Button("Login") {
                vm.login()
            }
            .buttonStyle(.bordered)
            
        }
        .padding(.horizontal, 20)
        .navigationTitle("Signup")
    }
}

#Preview {
    SignupView(vm: .init())
}

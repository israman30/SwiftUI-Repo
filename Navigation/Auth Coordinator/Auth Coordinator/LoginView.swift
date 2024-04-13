//
//  LoginView.swift
//  Auth Coordinator
//
//  Created by Israel Manzo on 4/13/24.
//

import SwiftUI

struct LoginView: View {
    
    struct Output {
        var goToMain: () -> ()
        var goToForgotPassword: () -> ()
    }
    
    var output: Output
    
    var body: some View {
        VStack {
            Button {
                self.output.goToMain()
            } label: {
                Text("Login")
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                self.output.goToForgotPassword()
            } label: {
                Text("Forgot Password?")
                    .padding()
            }
            .buttonStyle(.bordered)
        }
    }
    
}

#Preview {
    LoginView(output: .init(goToMain: {}, goToForgotPassword: {}))
}

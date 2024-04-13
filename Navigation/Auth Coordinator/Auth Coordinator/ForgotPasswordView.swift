//
//  ForgotPasswordView.swift
//  Auth Coordinator
//
//  Created by Israel Manzo on 4/13/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    struct Output {
        var goToForgotPasswordSite: () -> ()
    }
    
    var output: Output
    
    var body: some View {
        VStack {
            Button {
                self.output.goToForgotPasswordSite()
            } label: {
                Text("Forgot Password")
                    .padding()
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    ForgotPasswordView(output: .init(goToForgotPasswordSite: {}))
}

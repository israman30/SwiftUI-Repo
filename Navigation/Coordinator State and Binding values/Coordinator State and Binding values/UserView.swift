//
//  UserView.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

struct UserView: View {
    
    @Binding var isUserLoggedIn: Bool
    
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(isUserLoggedIn ? .green : .red)
                
                Text(isUserLoggedIn ? "User is logged in" : "User is logged out")
                    .font(.title)
            }
            Text("John Doe")
                .font(.largeTitle)
            
            Text("johndoe@mail.com")
                .font(.subheadline)
        }
    }
}

#Preview {
    UserView(isUserLoggedIn: .constant(false))
}

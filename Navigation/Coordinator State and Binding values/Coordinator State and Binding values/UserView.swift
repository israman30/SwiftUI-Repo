//
//  UserView.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

struct UserView: View {
    
    @Binding var isUserLoggedIn: Bool
    var myViewModel: MyViewModel
    
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(isUserLoggedIn ? .green : .red)
                
                Text(myViewModel.isUserLoggedIn ? "\(myViewModel.username) is logged in" : "\(myViewModel.username) is logged out")
                    .font(.title)
            }
            
            Text(myViewModel.text)
                .font(.subheadline)
        }
    }
}

#Preview {
    UserView(isUserLoggedIn: .constant(false), myViewModel: .init())
}

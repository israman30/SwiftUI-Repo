//
//  UserView.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

struct UserView: View {
    var body: some View {
        VStack {
            Text("John Doe")
                .font(.largeTitle)
            
            Text("johndoe@mail.com")
                .font(.subheadline)
        }
    }
}

#Preview {
    UserView()
}

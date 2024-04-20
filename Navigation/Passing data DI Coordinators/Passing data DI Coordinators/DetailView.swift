//
//  DetailView.swift
//  Passing data DI Coordinators
//
//  Created by Israel Manzo on 4/19/24.
//

import SwiftUI

struct DetailView: View {
    
    let user: Users
    
    var body: some View {
        Form {
            Text("Hello, \(user.name)")
            Text("Eamil: \(user.email)")
        }
    }
}

#Preview {
    DetailView(user: Users(id: 0, name: "John Doe", email: "johndoe@mail.com"))
}

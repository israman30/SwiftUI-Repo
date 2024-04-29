//
//  DetailView.swift
//  Passing data DI Coordinators
//
//  Created by Israel Manzo on 4/19/24.
//

import SwiftUI

struct DetailView: View {
    
    let user: Users
    @EnvironmentObject private var coordinator: Coordinator
    @State var isPresented = false
    
    var body: some View {
        Form {
            Text("Hello, \(user.name)")
            Text("Eamil: \(user.email)")
            
            Section {
                Button {
                    coordinator.push(sheet: .sheet)
                } label: {
                    Text("Present Sheer")
                }
            }
            
        }
    }
}

#Preview {
    DetailView(user: Users(id: 0, name: "John Doe", email: "johndoe@mail.com"))
}

//
//  DetailView.swift
//  Passing data DI Coordinators
//
//  Created by Israel Manzo on 4/19/24.
//

import SwiftUI

struct DetailView: View {
    
    let model: Model
    
    var body: some View {
        Text("Hello, \(model.name)")
    }
}

#Preview {
    DetailView(model: Model(name: "John Doe"))
}

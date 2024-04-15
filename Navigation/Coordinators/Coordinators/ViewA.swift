//
//  ViewA.swift
//  Coordinators
//
//  Created by Israel Manzo on 4/14/24.
//

import SwiftUI

struct ViewA: View {
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        List {
            Button("Push to B") {
                coordinator.push(.viewB)
            }
            Button("Push to C") {
                coordinator.push(.viewC)
            }
        }.navigationTitle("View A")
    }
}

#Preview {
    ViewA()
}

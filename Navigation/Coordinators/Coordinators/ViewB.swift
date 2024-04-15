//
//  ViewB.swift
//  Coordinators
//
//  Created by Israel Manzo on 4/14/24.
//

import SwiftUI

struct ViewB: View {
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        List {
            Button("Go to View Last") {
                coordinator.push(.viewLast)
            }
        }
    }
}

#Preview {
    ViewB()
}

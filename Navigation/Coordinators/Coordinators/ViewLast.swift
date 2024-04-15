//
//  ViewLast.swift
//  Coordinators
//
//  Created by Israel Manzo on 4/14/24.
//

import SwiftUI

struct ViewLast: View {
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        VStack {
            Button("Pop") {
                coordinator.pop()
            }
            
            Button("Pop to root") {
                coordinator.popToRoot()
            }
        }
    }
}

#Preview {
    ViewLast()
}

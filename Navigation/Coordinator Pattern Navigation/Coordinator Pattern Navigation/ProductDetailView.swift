//
//  ProductDetailView.swift
//  Coordinator Pattern Navigation
//
//  Created by Israel Manzo on 4/3/24.
//

import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject var coordinator: Coordinator
    var body: some View {
        VStack {
            if coordinator.currentProduct != nil {
                Text("Prodct is: \(coordinator.currentProduct!)")
            }
            Button {
                coordinator.goHome()
            } label: {
                Text("Go home")
            }
        }
    }
}

#Preview {
    ProductDetailView()
        .environmentObject(Coordinator())
}

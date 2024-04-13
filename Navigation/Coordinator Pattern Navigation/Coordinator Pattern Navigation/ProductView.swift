//
//  ProductView.swift
//  Coordinator Pattern Navigation
//
//  Created by Israel Manzo on 4/3/24.
//

import SwiftUI

struct ProductView: View {
    @EnvironmentObject var coordinator: Coordinator
    var body: some View {
        VStack {
            List(coordinator.productsList, id: \.self) { prod in
                HStack {
                    Text(prod)
                    Spacer()
                    Button {
                        coordinator.gotToProductDetail(product: prod)
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(Color.accentColor)
                }
            }
            Button {
                coordinator.showSheet()
            } label: {
                Text("Sheet")
            }
        }
    }
}

#Preview {
    ProductView()
        .environmentObject(Coordinator())
}

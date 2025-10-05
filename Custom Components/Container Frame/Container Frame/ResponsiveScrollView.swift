//
//  ResponsiveScrollView.swift
//  Container Frame
//
//  Created by Israel Manzo on 10/4/25.
//

import SwiftUI

struct ResponsiveScrollView: View {
    var body: some View {
        VStack {
            ScrollView {
                ForEach(0..<10) { item in
                   SomeCard(item: item)
                        .containerRelativeFrame(.horizontal) { width, _ in
                            min(width * 0.9, 600) // Perfect reading width
                        }
                }
            }
            
            ModalView()
            
            SomeGridView()
        }
        .padding(.vertical)
    }
}

struct SomeCard: View {
    let item: Int
    var body: some View {
        Text("\(item)")
    }
}

struct ModalView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Confirmation")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Are you sure you want to delete this item?")
                .containerRelativeFrame(.horizontal) { width, _ in
                    min(width * 0.8, 400)
                }
                .multilineTextAlignment(.center)
            
            HStack {
                Button("Cancel") { }
                Button("Delete") { }
            }
        }
        .containerRelativeFrame(.horizontal) { width, _ in
            min(width * 0.9, 500) // Modal content scales with modal size
        }
        .padding()
    }
}

struct SomeGridView: View {
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.adaptive(minimum: 120))
        ]) {
            ForEach(0..<10) { product in
                ProductCard(product: product)
                    .containerRelativeFrame(.horizontal) { width, _ in
                        // Each card takes appropriate width within its grid cell
                        width * 0.95
                    }
                    .aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

struct ProductCard: View {
    let product: Int
    var body: some View {
        Text("Some: \(product)")
    }
}

#Preview {
    ResponsiveScrollView()
}

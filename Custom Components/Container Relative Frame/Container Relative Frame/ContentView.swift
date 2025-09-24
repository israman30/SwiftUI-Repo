//
//  ContentView.swift
//  Container Relative Frame
//
//  Created by Israel Manzo on 9/23/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ContainerRelativeFrameDemo()
        }
    }
}

#Preview {
    ContentView()
}

struct ContainerRelativeFrameDemo: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 8) {
                ForEach(0..<10, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.blue.opacity(0.8))
                        .containerRelativeFrame([.vertical], count: 3, span: index % 2 + 1, spacing: 24)
                }
            }
            .padding()
        }
    }
}

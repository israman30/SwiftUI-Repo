//
//  ContentView.swift
//  Animations Samples
//
//  Created by Israel Manzo on 7/5/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            HStack {
                Text("Scale Button")
                Spacer()
                ScaleButton()
            }
        }
    }
}

#Preview {
    ContentView()
}

/** `Use .animation(_:value:) with explicit value bindings to ensure stable behavior. */
struct ScaleButton: View {
    @State private var isPressed = false

    var body: some View {
        Circle()
            .fill(isPressed ? .green : .blue)
            .frame(width: isPressed ? 100 : 50)
            .animation(.easeInOut(duration: 0.3), value: isPressed)
            .onTapGesture {
                isPressed.toggle()
            }
    }
}

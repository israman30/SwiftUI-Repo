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
            HStack {
                Text("Scale Button")
                Spacer()
                MatchedCardTransition()
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

struct MatchedCardTransition: View {
    @Namespace private var namespace
    @State private var showDetail = false

    var body: some View {
        VStack {
            if !showDetail {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.blue)
                    .matchedGeometryEffect(id: "card", in: namespace)
                    .frame(height: 100)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            showDetail.toggle()
                        }
                    }
            } else {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.blue)
                    .matchedGeometryEffect(id: "card", in: namespace)
                    .frame(height: 300)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            showDetail.toggle()
                        }
                    }
            }
        }
        .padding()
    }
}

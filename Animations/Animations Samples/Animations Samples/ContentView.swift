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
            HStack {
                Text("Scale Button")
                Spacer()
                BouncyScaleView()
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

/**
 - Explicit Animations with `withAnimation`
 You can use this for grouped animations, conditional flows, or gesture-based updates.
 
 ```
 withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
     self.isPressed.toggle()
 }

 */
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

/**
 `iOS 18: `KeyframeAnimator` for Timeline Animations
 New in iOS 18, `KeyframeAnimator` lets you create smooth, timeline-based animations.
 */
struct BouncyScaleView: View {
    @State private var isActive = false

    var body: some View {
        KeyframeAnimator(initialValue: 1.0, trigger: isActive) { value in
            Circle()
                .scaleEffect(value)
                .frame(width: 100, height: 100)
                .onTapGesture { isActive.toggle() }
        } keyframes: { _ in
            KeyframeTrack {
                SpringKeyframe(1.5, duration: 0.2)
                SpringKeyframe(0.9, duration: 0.15)
                SpringKeyframe(1.0, duration: 0.1)
            }
        }
    }
}

//
//  ContentView.swift
//  Card Stack
//
//  Created by Israel Manzo on 9/12/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CardStackView()
    }
}

#Preview {
    ContentView()
}

struct CardStackView: View {
    @State private var cards = ["goku", "attack", "ranma"]
    @State private var dragOffset = CGSize.zero
    @State private var isSwiping = false
    
    @State private var isAnimatingOut = false
    @State private var animateTopCardOut = false
    @State private var fadeOut = false
    var body: some View {
        ZStack {
            ForEach(Array(cards.enumerated()), id: \.element) { index, imageName in
                CardView(imageName: imageName)
                    .scaleEffect(scale(for: index))
                    .offset(offset(for: index))
                    .zIndex(Double(cards.count - index))
                    .opacity(index == 0 ? (fadeOut ? 0 : 1) : 1)
                    .rotationEffect(Angle(degrees: Double(index == 0 ? 2.5 : index == 1 ? -5 : 5)))
                    .animation(.linear(duration: 0.4), value: dragOffset)
                    .animation(.easeInOut(duration: 0.4), value: animateTopCardOut)
                    .animation(.easeOut(duration: 0.4), value: fadeOut)
                    .onTapGesture {
                        swipeTopCard()
                    }
            }
        }
        .frame(width: 400, height: 500)
        .onAppear {
            startAutoPop()
        }
    }
    private func startAutoPop() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            swipeTopCard()
        }
    }
    private func swipeTopCard() {
        isSwiping = true
        isAnimatingOut = true
        animateTopCardOut = true
        fadeOut = true
        let direction: CGFloat = dragOffset.width > 0 ? 1 : -1
        withAnimation(.easeInOut(duration: 1.0)) {
            dragOffset = CGSize(width: direction * 600, height: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let first = cards.removeFirst()
            cards.append(first)
            dragOffset = .zero
            isSwiping = false
            fadeOut = false
        }
    }
    private func scale(for index: Int) -> CGFloat {
        switch index {
        case 0: return 1.0
        case 1: return 0.95
        case 2: return 0.9
        default: return 0.9
        }
    }
    private func offset(for index: Int) -> CGSize {
        switch index {
        case 0: return .zero
        case 1: return CGSize(width: 0, height: 10)
        case 2: return CGSize(width: 0, height: 20)
        default: return CGSize(width: 0, height: 30)
        }
    }
}
struct CardView: View {
    let imageName: String
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 240, height: 300)
    }
}
#Preview{
    CardStackView()
        .background(.gray)
}

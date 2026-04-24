//
//  ContentView.swift
//  Canvas Background Page Style
//
//  Created by Israel Manzo on 4/24/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            LinePaperBackground()
        }
    }
}

#Preview {
    ContentView()
}

struct LinePaperBackground: View {
    private let lineSpacing: CGFloat = 28
    private let redMarginColor = Color.red.opacity(0.5)
    private let blueMarginColor = Color.blue.opacity(0.5)
    private let marginWidth: CGFloat = 40
    private let redMarginWidth: CGFloat = 10
    
    var body: some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            ZStack(alignment: .leading) {
                Color.white
                Canvas { context, size in
                    // Horizontal lines
                    var y: CGFloat = lineSpacing
                    while y < height {
                        var path = Path()
                        path.move(to: CGPoint(x: redMarginWidth, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                        context.stroke(path, with: .color(blueMarginColor), lineWidth: 0.5)
                        y += lineSpacing
                    }
                    // left margin line
                    var marginPath = Path()
                    marginPath.move(to: CGPoint(x: marginWidth, y: 0))
                    marginPath.addLine(to: CGPoint(x: marginWidth, y: height))
                    context.stroke(marginPath, with: .color(redMarginColor), lineWidth: 1)
                }
            }
        }
    }
}

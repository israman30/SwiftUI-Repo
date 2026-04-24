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

#Preview {
    GridPaperBackgroung()
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

struct GridPaperBackgroung: View {
    private let lineColor = Color.blue.opacity(0.3)
    private let gridSpacing: CGFloat = 20
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            ZStack {
                Color.white
                Canvas { context, size in
                    // vertical line
                    var x: CGFloat = 0
                    while x <= width {
                        var path = Path()
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: height))
                        context.stroke(path, with: .color(lineColor), lineWidth: 0.5)
                        x += gridSpacing
                    }
                    // horizontal lines
                    var y: CGFloat = 0
                    while y <= height {
                        var path = Path()
                        path.move(to: CGPoint(x: 0,y: y))
                        path.addLine(to: CGPoint(x: width,y: y))
                        context.stroke(path, with: .color(lineColor), lineWidth: 0.5)
                        y += gridSpacing
                    }
                }
            }
        }
    }
}

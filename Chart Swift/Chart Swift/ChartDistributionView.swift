//
//  ChartDistributionView.swift
//  Chart Swift
//
//  Created by Israel Manzo on 2/11/25.
//

import SwiftUI
import Charts

struct ChartDistributionView: View {
    var body: some View {
        VStack {
            PieChartView(data: [10, 20, 30, 40], colors: [.red, .green, .blue, .yellow])
        }
    }
}

#Preview {
    ChartDistributionView()
}

struct PieChartView: View {
    let data: [Double]
    let colors: [Color]
    
    var total: Double {
        data.reduce(0, +)
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<data.count, id: \.self) { index in
                PieSlice(startAngle: startAngle(for: index), endAngle: endAngle(for: index))
                    .fill(colors[index])
                    .padding()
            }
        }
    }
    
    private func startAngle(for index: Int) -> Angle {
        let start = data.prefix(index).reduce(0, +) / total * 360
        return Angle(degrees: start)
    }
    
    private func endAngle(for index: Int) -> Angle {
        let end = data.prefix(index + 1).reduce(0, +) / total * 360
        return Angle(degrees: end)
    }
}

struct PieSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.size.width, rect.size.height) / 2
        let start = CGPoint(
            x: center.x + radius * cos(CGFloat(startAngle.radians)),
            y: center.y + radius * sin(CGFloat(startAngle.radians))
        )
        let end = CGPoint(
            x: center.x + radius * cos(CGFloat(endAngle.radians)),
            y: center.y + radius * sin(CGFloat(endAngle.radians))
        )

        var path = Path()
        path.move(to: center)
        path.addLine(to: start)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addLine(to: center)
        return path
    }
}

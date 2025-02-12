//
//  CustomChartView.swift
//  Chart Swift
//
//  Created by Israel Manzo on 2/11/25.
//

import SwiftUI
import Charts

struct CustomChartView: View {
    var body: some View {
        VStack {
            barMark
            pointMark
        }
    }
    
    var barMark: some View {
        Chart(someData) {
            BarMark(
                x: .value("Month", $0.month),
                y: .value("Sales", $0.sales)
            )
        }
        .foregroundStyle(LinearGradient(colors: [.blue, .red], startPoint: .leading, endPoint: .trailing))
    }
    
    var pointMark: some View {
        Chart(someData) {
            PointMark(
                x: .value("Month", $0.month),
                y: .value("Sales", $0.sales)
            )
            .foregroundStyle(by: .value("Family", $0.month))
        }
    }
}

#Preview {
    CustomChartView()
}


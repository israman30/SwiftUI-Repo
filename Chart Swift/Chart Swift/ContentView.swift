//
//  ContentView.swift
//  Chart Swift
//
//  Created by Israel Manzo on 2/11/25.
//

import SwiftUI
import Charts

struct SomeData: Identifiable {
    var id = UUID()
    let month: String
    let sales: Double
}

let someData: [SomeData] = [
    .init(month: "Jan", sales: 100),
    .init(month: "Feb", sales: 200),
    .init(month: "Mar", sales: 300),
    .init(month: "Apr", sales: 400),
    .init(month: "May", sales: 500),
    .init(month: "Jun", sales: 600),
    .init(month: "Jul", sales: 700),
    .init(month: "Aug", sales: 800),
    .init(month: "Sep", sales: 900),
]

struct ContentView: View {
    var body: some View {
        VStack {
            ChartView()
            AreaChartView()
        }
    }
}

#Preview {
    ContentView()
}

struct ChartView: View {
    var body: some View {
        Chart {
            ForEach(someData) { data in
                BarMark(
                    x: .value("Month", data.month),
                    y: .value("Sales", data.sales)
                )
            }
        }
        .frame(height: 300)
        .padding()
    }
}

struct AreaChartView: View {
    var body: some View {
        Chart {
            ForEach(someData) { data in
                AreaMark(
                    x: .value("Month", data.month),
                    y: .value("Sales", data.sales)
                )
            }
        }
        .frame(height: 300)
        .padding()
    }
}

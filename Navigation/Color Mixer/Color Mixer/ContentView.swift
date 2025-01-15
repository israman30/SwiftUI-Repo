//
//  ContentView.swift
//  Color Mixer
//
//  Created by Israel Manzo on 1/14/25.
//

import SwiftUI

struct ContentView: View {
    @State var leftColor: Color = .red
    @State var rightColor: Color = .blue
    @State var mix: Double = 0
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                ColorPicker("Left Color", selection: $leftColor)
                    .labelsHidden()
                ColorPicker("Right Color", selection: $rightColor)
                    .labelsHidden()
            }
            HStack {
                VStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(leftColor)
                        .frame(width: 100, height: 100)
                    Text("\((1 - mix), format: .percent.precision(.fractionLength(0...2)))")
                }
                VStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(rightColor)
                        .frame(width: 100, height: 100)
                    Text("\((mix), format: .percent.precision(.fractionLength(0...2)))")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

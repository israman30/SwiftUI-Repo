//
//  CustomProgressView.swift
//  Custom ProgressView
//
//  Created by Israel Manzo on 10/19/24.
//

import SwiftUI

struct CustomProgressView: View {
    
    @State private var progress: Double = 0.75
    
    var body: some View {
        ProgressView(value: progress)
            .progressViewStyle(CustomCircularProgressViewStyle())
            .padding()
    }
}

struct CustomCircularProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: CGFloat(configuration.fractionCompleted ?? 0))
                .stroke(Color.blue, lineWidth: 10)
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: configuration.fractionCompleted)
            Text(String(format: "%.0f%%", (configuration.fractionCompleted ?? 0) * 100))
                .font(.largeTitle)
                .bold()
        }
    }
}

#Preview {
    CustomProgressView()
}

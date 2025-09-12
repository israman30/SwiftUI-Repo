//
//  AccessibilityProgressView.swift
//  Custom ProgressView
//
//  Created by Israel Manzo on 10/19/24.
//

import SwiftUI

struct AccessibilityProgressView: View {
    
    @State private var progress: Double = 0.5
    
    var body: some View {
        ProgressView("Loading...", value: progress)
            .progressViewStyle(.circular)
            .accessibilityLabel(Text("Loading progress"))
            .accessibilityValue(Text("\(Int(progress * 100)) percent completed"))
            .padding()
    }
}

#Preview {
    AccessibilityProgressView()
}

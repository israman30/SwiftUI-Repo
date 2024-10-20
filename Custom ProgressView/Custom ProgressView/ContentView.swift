//
//  ContentView.swift
//  Custom ProgressView
//
//  Created by Israel Manzo on 10/19/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            DefaultProgressView()
        }
        .padding()
    }
}

struct DefaultProgressView: View {
    
    @State var progress: Double = 0.5
    
    var body: some View {
        ProgressView(value: progress)
            .progressViewStyle(.automatic)
    }
}

struct CustomPodgressView: View {
    var body: some View {
        ProgressView()
    }
}

#Preview {
    ContentView()
}

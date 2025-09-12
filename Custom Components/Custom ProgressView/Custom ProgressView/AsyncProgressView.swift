//
//  AsyncProgressView.swift
//  Custom ProgressView
//
//  Created by Israel Manzo on 10/19/24.
//

import SwiftUI

struct AsyncProgressView: View {
    
    @State var progress: Double = 0.5
    
    var body: some View {
        VStack {
            ProgressView(value: progress)
                .progressViewStyle(.linear)
                .padding()
            
            Button("Start Progress") {
                Task {
                    await startAsyncTask()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    func startAsyncTask() async {
        for i in 0...10 {
            try? await Task.sleep(nanoseconds: 500_000_000) // Sleep for 0.5 seconds
            progress = Double(i) / 10.0
        }
    }
}

#Preview {
    AsyncProgressView()
}

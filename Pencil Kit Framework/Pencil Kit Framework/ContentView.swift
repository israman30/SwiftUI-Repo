//
//  ContentView.swift
//  Pencil Kit Framework
//
//  Created by Israel Manzo on 8/7/25.
//

import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
}

struct ContentView: View {
    @State private var canvas = PKCanvasView()
    @State private var toolPicker = PKToolPicker()
    
    var body: some View {
        ZStack {
            CanvasView(canvas: $canvas)
                .onAppear {
                    if let window = UIApplication.shared.connectedScenes.first {
                        toolPicker.setVisible(true, forFirstResponder: canvas)
                        toolPicker.addObserver(canvas)
                        canvas.becomeFirstResponder()
                    }
                }
            VStack {
                HStack {
                    Spacer()
                    Button("Clear") {
                        canvas.drawing = .init()
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}

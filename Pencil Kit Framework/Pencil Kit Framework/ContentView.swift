//
//  ContentView.swift
//  Pencil Kit Framework
//
//  Created by Israel Manzo on 8/7/25.
//

import SwiftUI
import PencilKit
import SwiftData

struct CanvasView: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    @Binding var showToolPicker: Bool
    
    private let canvasView = PKCanvasView()
    private let toolPicker = PKToolPicker()
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        if showToolPicker {
            canvasView.becomeFirstResponder()
        }
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        toolPicker.setVisible(showToolPicker, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        if showToolPicker {
            canvasView.becomeFirstResponder()
        } else {
            canvasView.resignFirstResponder()
        }
        
        if drawing != canvasView.drawing {
            canvasView.drawing = drawing
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(drawing: $drawing)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var drawing: Binding<PKDrawing>
        init(drawing: Binding<PKDrawing>) {
            self.drawing = drawing
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            drawing.wrappedValue = canvasView.drawing
        }
    }
}

struct ContentView: View {
    @State private var showToolPicker: Bool = false
    @State private var drawing = PKDrawing()
    
    var body: some View {
        NavigationView {
            CanvasView(drawing: $drawing, showToolPicker: $showToolPicker)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Erase all", systemImage: "trash") {
                            drawing = PKDrawing()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Paint", systemImage: "brush") {
                            showToolPicker.toggle()
                        }
                    }
//                    ToolbarItem(placement: .topBarLeading) {
//                        Button("Save drawing", systemImage: "arrow.down.doc") {
//                            Task {
//                                try await drawing.savePhotoLibrary()
//                            }
//                        }
//                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        ShareLink(item: drawing.image(), subject: Text("Drawing"), message: Text("Drawing something cool!"), preview: SharePreview("Drawing", image: drawing.image())) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}

extension PKDrawing {
    func savePhotoLibrary() async throws {
        let uiImage = self.image(from: self.bounds, scale: 1)
        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
    }
}

// PERSISTENCE
@Model
class DrawingnModel {
    private var drawingData: Data
    
    var drawing: PKDrawing {
        get {
            (try? PKDrawing(data: drawingData)) ?? PKDrawing()
        }
        set {
            drawingData = newValue.dataRepresentation()
        }
    }
    
    init(drawingData: Data) {
        self.drawingData = drawingData
    }
    
    init(drawing: PKDrawing) {
        self.drawingData = drawing.dataRepresentation()
    }
    
    init() {
        drawingData = Data()
    }
}

extension PKDrawing {
    func savePhotoLibrary() {
        
    }
    
    func image() -> Image {
        let uiImage = self.image(from: self.bounds, scale: 1)
        return Image(uiImage: uiImage)
    }
}

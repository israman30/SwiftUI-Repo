//
//  ContentView.swift
//  RGB generator
//
//  Created by Israel Manzo on 12/15/23.
//

import SwiftUI
import Combine

final class SliderComponent: ObservableObject {
    @Published var redColor = 0.0
    @Published var greenColor = 0.0
    @Published var blueColor = 0.0
}

struct ContentView: View {
    
    @State var redcolor = 0.0
    @State var greenColor = 0.0
    @State var blueColor = 0.0
    @State var sliderColor: Color = .red
    
    @StateObject var sliderComponent = SliderComponent()
    
    var rgbColor: Color {
        Color(red: redcolor, green: greenColor, blue: blueColor)
    }
    
    var body: some View {
        Form {
            
            Circle()
                .onSubmit {
                    
                }
                .foregroundStyle(rgbColor)
            Section("Color") {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                
                Text("Hello, world!")
                Slider(value: $redcolor, in: 0...255, step: 0.5)
                    .onChange(of: self.redcolor) {
                        sliderColor = rgbColor
                    }
                Text("\(redcolor)")
                Slider(value: $greenColor, in: 0...255, step: 0.5)
                    .onChange(of: self.greenColor) {
                        sliderColor = rgbColor
                    }
                Text("\(greenColor)")
                Slider(value: $blueColor, in: 0...255, step: 0.5)
                    .onChange(of: self.blueColor) {
                        sliderColor = rgbColor
                    }
                Text("\(blueColor)")
            }
            
        }
        
    }
}

#Preview {
    ContentView()
}

class RGBGenerator {
    
}

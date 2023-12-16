//
//  ContentView.swift
//  RGB generator
//
//  Created by Israel Manzo on 12/15/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var redcolor = 0.0
    @State var greenColor = 0.0
    @State var blueColor = 0.0
    
    var body: some View {
        Form {
            
            Circle()
                .foregroundStyle(Color(red: redcolor, green: greenColor, blue: blueColor))
            Section("Color") {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                
                Text("Hello, world!")
                Slider(value: $redcolor, in: 0...100, step: 0.5)
                Text("\(redcolor)")
                Slider(value: $greenColor, in: 0...100, step: 0.5)
                Text("\(greenColor)")
                Slider(value: $blueColor, in: 0...100, step: 0.5)
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

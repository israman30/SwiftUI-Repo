//
//  ContentView.swift
//  Accesibility Components
//
//  Created by Israel Manzo on 1/2/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var volumeValue: Double = 0
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Hello, world!")
                .onTapGesture {
                    print("Submitted")
                }
                .accessibility(
                    options: [
                        .traits([.isButton])
                    ]
                )
            
            Button {
                
            } label: {
                Text("Tap")
            }
            .accessibility(
                options: [
                    .traits([.isButton])
                ]
            )
            .buttonStyle(.borderedProminent)
            
            Slider(value: $volumeValue, in: 0...100)
                .accessibility(
                    options: [
                        .labels("Volume"),
                        .value("\(Int(volumeValue)) %"),
                        .hint("Adjust the volume")
                    ]
                )
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

struct AnotherView: View {
    @State var someValue: Double = 0
    @State var isToggled = false
    var body: some View {
        VStack {
            Text("Settings")
                .accessibility(
                    options: [
                        .traits([.isHeader])
                    ]
                )
            Slider(value: $someValue, in : 0...100)
                .accessibility(options: [.accessibilityHidden])
            Toggle("Enable feature", isOn: $isToggled)
                .accessibility(
                    options: [
                        .labels("This will be readed by VoiceOver"),
                        .hint("Enables the feature")
                    ]
                )
        }
        .accessibility(
            options: [
                .behaviour(.contain),
                .labels("This will be read by VoiceOver")
            ]
        )
        
    }
        
}

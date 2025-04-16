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
                        .hint("Adjust the volume"),
                        .behaviour(children: .combine)
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
                .behaviour(children: .contain),
                .labels("This will be read by VoiceOver")
            ]
        )
        .accessibilityAnnouncement(.layoutChanged)
        
    }
        
}

struct AccessibilityAnnouncement: ViewModifier {
    let notification: UIAccessibility.Notification
    var argument: Any?
    var delay: CGFloat = 0.1
    func body(content: Content) -> some View {
        content
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    UIAccessibility.post(notification: notification, argument: argument)
                }
            }
    }
}

extension View {
    public func accessibilityAnnouncement(_ notification: UIAccessibility.Notification, argument: Any? = nil, delay: CGFloat = 0.1) -> some View {
        modifier(AccessibilityAnnouncement(notification: notification, argument: argument, delay: delay))
    }
}

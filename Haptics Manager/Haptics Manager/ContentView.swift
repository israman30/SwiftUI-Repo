//
//  ContentView.swift
//  Haptics Manager
//
//  Created by Israel Manzo on 1/15/25.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    @State var value1 = false
    @State var value2 = false
    @State var value3 = false
    @State var value4 = false
    
    var body: some View {
        List {
            Button("High Intesity") {
                value1.toggle()
            }
            .sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: value1)
            
            Button("Increase Intensity") {
                value2.toggle()
            }
            .sensoryFeedback(.increase, trigger: value2)
            
            Button("Success") {
                value3.toggle()
            }
            .sensoryFeedback(.success, trigger: value3)
            
            Button("Error") {
                value4.toggle()
            }
            .sensoryFeedback(.error, trigger: value4)
        }
    }
}

#Preview {
    ContentView()
}

struct CustomHapticsManager: View {
    
    @State var hapticEngine: CHHapticEngine?
    
    var body: some View {
        Button("Start") {

        }
    }
    
    private func prepareHapticEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Error starting haptic engine: \(error.localizedDescription)")
        }
    }
    
    private func playHappyHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        
        var events = [CHHapticEvent]()
        
        for time in stride(from: 0, to: 1, by: 0.3) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(time))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(time))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: time)
            
            events.append(event)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: .zero)
        } catch {
            print("Error playing haptic pattern: \(error.localizedDescription)")
        }
    }
}

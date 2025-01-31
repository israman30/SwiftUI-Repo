//
//  ContentView.swift
//  Analytics System Track Event
//
//  Created by Israel Manzo on 1/30/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(FirebaseAnalyticsManager.self) var firabaseAnalyticsManager
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            trackEvent()
        }
    }
    
    private func trackEvent() {
        firabaseAnalyticsManager.trackEvent(
            .init(
                name: "App Launch",
                properties: [
                    "userId": "12345",
                    "Launch Count": 1,
                    "timestamp" : Date()
                ]
            )
        )
    }
}

#Preview {
    ContentView()
        .environment(FirebaseAnalyticsManager(firebaseServices: FirebaseAanalyticsService()))
}

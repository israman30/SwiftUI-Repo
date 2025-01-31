//
//  DetailView.swift
//  Analytics System Track Event
//
//  Created by Israel Manzo on 1/30/25.
//

import SwiftUI

struct DetailView: View {
    @Environment(MixpanelAnalyticsManager.self) var mixpanelAnaylitcsManager
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                mixpanelAnaylitcsManager.trackEvent(
                    .init(
                        name: "App Launch",
                        properties: [
                            "userId": "342342",
                            "Launch Count": 1,
                            "timestamp" : Date()
                        ]
                    )
                )
            }
    }
}

#Preview {
    DetailView()
        .environment(MixpanelAnalyticsManager(mixpanelServices: MixpanelAanalyticsSerrvice()))
}

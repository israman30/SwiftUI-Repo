//
//  Analytics_System_Track_EventApp.swift
//  Analytics System Track Event
//
//  Created by Israel Manzo on 1/30/25.
//

import SwiftUI

@main
struct Analytics_System_Track_EventApp: App {
    
    @State private var firebaseAnalyticsManagaer = FirebaseAnalyticsManager(firebaseServices: FirebaseAanalyticsService())
    @State private var mixpanelAnalyticsManagaer = MixpanelAnalyticsManager(mixpanelServices: MixpanelAanalyticsSerrvice())
                                                                            
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(firebaseAnalyticsManagaer)
                .environment(mixpanelAnalyticsManagaer)
        }
    }
}

//
//  AnalyticsService.swift
//  Analytics System Track Event
//
//  Created by Israel Manzo on 1/30/25.
//

import Foundation

public struct Event {
    let name: String
    let properties: [String: Any]
}

public protocol AnalyticsService: Sendable {
    func track(_ event: Event)
    func unset(_ event: Event)
}

class AnalyticsManager {
    func trackEvent(_ event: Event) {
        
    }
    
    func trackEvents(_ events: [Event]) {
        
    }
}

struct FirebaseAanaltics: AnalyticsService {
    func track(_ event: Event) {
        // track event
    }
    
    func unset(_ event: Event) {
        //  track event
    }
}

struct MixpanelAanaltics: AnalyticsService {
    func track(_ event: Event) {
        // track event
    }
    
    func unset(_ event: Event) {
        //  track event
    }
}

//
//  AnalyticsService.swift
//  Analytics System Track Event
//
//  Created by Israel Manzo on 1/30/25.
//

import Foundation
import Observation

public struct Event {
    let name: String
    let properties: [String: Any]
}

public protocol AnalyticsService: Sendable {
    func track(_ event: Event)
    func unset(_ event: Event)
}

@Observable
class FirebaseAnalyticsManager {
    
    private var firebaseServices: FirebaseAanalyticsService
    
    init(firebaseServices: FirebaseAanalyticsService) {
        self.firebaseServices = firebaseServices
    }
    
    func trackEvent(_ event: Event) {
        firebaseServices.track(event)
    }
    
    func unsetEvent(_ event: Event) {
        firebaseServices.unset(event)
    }
}

@Observable
class MixpanelAnalyticsManager {
    
    private var mixpanelServices: MixpanelAanalyticsSerrvice
    
    init(mixpanelServices: MixpanelAanalyticsSerrvice) {
        self.mixpanelServices = mixpanelServices
    }
    
    func trackEvent(_ event: Event) {
        mixpanelServices.track(event)
    }
    
    func unsetEvent(_ event: Event) {
        mixpanelServices.unset(event)
    }
}

struct FirebaseAanalyticsService: AnalyticsService {
    
    init () {
        // initialize service
    }
    
    func track(_ event: Event) {
        // track event
    }
    
    func unset(_ event: Event) {
        //  track event
    }
}

struct MixpanelAanalyticsSerrvice: AnalyticsService {
    
    init () {
        // initialize service
    }
    
    func track(_ event: Event) {
        // track event
    }
    
    func unset(_ event: Event) {
        //  track event
    }
}

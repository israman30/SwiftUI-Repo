//
//  README.swift
//  Analytics System Track Event
//
//  Created by Israel Manzo on 1/30/25.
//

/**
 ```______________________
    Event  | struct
    props  | [String:Any]
    ______________________
 
 
 
                              Dependency Injection
            AnalyticService   ---------------------> AnalyticsManager ----> Views
              (protocol)
                  |
                  |
                  /\
 FirebaseAnalytics  MixPanelAnalytics
 
 ```
 */

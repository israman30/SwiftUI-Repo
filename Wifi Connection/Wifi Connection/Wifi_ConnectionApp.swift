//
//  Wifi_ConnectionApp.swift
//  Wifi Connection
//
//  Created by Israel Manzo on 5/26/24.
//

import SwiftUI

@main
struct Wifi_ConnectionApp: App {
    @State private var networkMonitor = NetworkMonitor()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(networkMonitor)
        }
    }
}

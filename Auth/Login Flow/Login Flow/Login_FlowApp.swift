//
//  Login_FlowApp.swift
//  Login Flow
//
//  Created by Israel Manzo on 5/5/26.
//

import SwiftUI

/// Application entry point.
///
/// The login flow is rooted at `ContentView`, which creates and injects an `AppCoordinator`.
@main
struct Login_FlowApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

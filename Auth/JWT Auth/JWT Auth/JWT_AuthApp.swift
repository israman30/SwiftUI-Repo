//
//  JWT_AuthApp.swift
//  JWT Auth
//
//  Created by Israel Manzo on 5/2/26.
//

import SwiftUI

@main
struct JWT_AuthApp: App {
    // Single source of truth for auth across the app.
    @StateObject private var auth = AuthStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Allows any view to reactively switch UI based on auth state.
                .environmentObject(auth)
        }
    }
}

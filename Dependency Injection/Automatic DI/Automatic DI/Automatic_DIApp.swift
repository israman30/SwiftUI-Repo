//
//  Automatic_DIApp.swift
//  Automatic DI
//
//  Created by Israel Manzo on 4/16/25.
//

import SwiftUI

@main
struct Automatic_DIApp: App {
    
    init() {
        AppModule.inject() // Provides all the dependencies
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

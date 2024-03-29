//
//  NetworkingApp.swift
//  Networking
//
//  Created by Israel Manzo on 1/6/23.
//

import SwiftUI

@main
struct NetworkingApp: App {
    var network = NetworkServices()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(network)
        }
    }
}

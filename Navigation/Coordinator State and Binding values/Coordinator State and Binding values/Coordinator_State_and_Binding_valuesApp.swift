//
//  Coordinator_State_and_Binding_valuesApp.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

@main
struct Coordinator_State_and_Binding_valuesApp: App {
    @StateObject var coordinator: Coordinator = .init()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coordinator)
        }
    }
}

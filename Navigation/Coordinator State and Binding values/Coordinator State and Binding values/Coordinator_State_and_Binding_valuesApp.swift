//
//  Coordinator_State_and_Binding_valuesApp.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

@main
struct Coordinator_State_and_Binding_valuesApp: App {
    // MARK: - Coordinator Navigation
    @StateObject var coordinator: Coordinator = .init()
    
    // MARK: - ViewModel Object init()
    @StateObject var myViewModel: MyViewModel = .init()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coordinator) // Coordinator stored and available in the view hierachy
                .environmentObject(myViewModel) // ViewModel stored and available in the view hierachy
        }
    }
}

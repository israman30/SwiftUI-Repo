//
//  Todo_ListApp.swift
//  Todo List
//
//  Created by Israel Manzo on 2/9/25.
//

import SwiftUI
import SwiftData

@main
struct Todo_ListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: TodoItem.self)
        }
    }
}

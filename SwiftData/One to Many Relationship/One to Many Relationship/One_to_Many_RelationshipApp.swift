//
//  One_to_Many_RelationshipApp.swift
//  One to Many Relationship
//
//  Created by Israel Manzo on 8/14/25.
//

import SwiftUI
import SwiftData

@main
struct One_to_Many_RelationshipApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

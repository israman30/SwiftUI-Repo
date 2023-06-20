//
//  Fetch_API_and_store_in_Core_DataApp.swift
//  Fetch API and store in Core Data
//
//  Created by Israel Manzo on 6/19/23.
//

import SwiftUI

@main
struct Fetch_API_and_store_in_Core_DataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

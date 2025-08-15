//
//  ContentView.swift
//  One to Many Relationship
//
//  Created by Israel Manzo on 8/14/25.
//

import SwiftUI
import SwiftData

@Model
class Owner {
    var name: String
    var cars: [Car] = []
    
    init(name: String) {
        self.name = name
    }
}

@Model
class Car {
    var make: String
    var registrationNumber: String
    var owner: Owner?
    
    init(make: String, registrationNumber: String, owner: Owner? = nil) {
        self.make = make
        self.registrationNumber = registrationNumber
        self.owner = owner
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

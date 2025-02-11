//
//  ContentView.swift
//  NoteApp
//
//  Created by Israel Manzo on 2/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var notes: [NoteItem]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(notes) { note in
                    Text(note.title)
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                Button {
                    addNote()
                } label: {
                    Label("Add Note", systemImage: "plus")
                }
            }
        }
    }
    
    func addNote() {
        let newNote = NoteItem(title: "John Doe", content: "some content", isCompleted: true)
        context.insert(newNote)
    }
}

#Preview {
    ContentView()
}

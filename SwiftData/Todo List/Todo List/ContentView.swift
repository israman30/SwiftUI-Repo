//
//  ContentView.swift
//  Todo List
//
//  Created by Israel Manzo on 2/9/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context
    @State private var showAddTodoView = false
    @Query private var items: [TodoItem]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items, id: \TodoItem.timestamp) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            if item.isImportant {
                                Image(systemName: "exclamationmark.3")
                                    .symbolVariant(.fill)
                                    .foregroundStyle(.red)
                                    .font(.largeTitle)
                                    .bold()
                            }
                            Text(item.title)
                                .font(.largeTitle)
                                .bold()
//                            Text("\(item.timstamp)")
//                                .font(.callout)
                        }
                        Spacer()
                        Button {
                            withAnimation {
                                item.isCompleted.toggle()
                            }
                        } label: {
                            Image(systemName: "checkmark")
                                .symbolVariant(.fill)
                                .foregroundStyle(item.isCompleted ? .green : .gray)
                                .font(.largeTitle)
                                .bold()
                        }
                        .buttonStyle(.plain)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            withAnimation {
                                context.delete(item)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .symbolVariant(.fill)
                        }
                    }
                }
            }
            .navigationTitle("Swift Data Todo")
            .toolbar {
                Button {
                    showAddTodoView.toggle()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showAddTodoView) {
                NavigationStack {
                    CreaterTodoView()
                }
                .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    ContentView()
}

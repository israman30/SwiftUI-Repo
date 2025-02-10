//
//  CreaterTodoView.swift
//  Todo List
//
//  Created by Israel Manzo on 2/9/25.
//

import SwiftUI

struct CreaterTodoView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @State var item = TodoItem()
    
    var body: some View {
        List {
            TextField("Add Todo", text: $item.title)
            DatePicker("Date", selection: $item.timestamp)
            Toggle("Is important?", isOn: $item.isImportant)
            Button("Create") {
                withAnimation {
                    context.insert(item)
                }
                dismiss()
            }
        }
    }
}

#Preview {
    CreaterTodoView()
        .modelContainer(for: TodoItem.self)
}

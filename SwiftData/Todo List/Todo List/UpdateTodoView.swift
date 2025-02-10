//
//  UpdateTodoViw.swift
//  Todo List
//
//  Created by Israel Manzo on 2/10/25.
//

import SwiftUI

struct UpdateTodo: View {
    @Environment(\.dismiss) var dimiss
    @Bindable var item: TodoItem
    
    var body: some View {
        List {
            TextField("Title", text: $item.title)
            DatePicker("Due Date", selection: $item.timestamp)
            Toggle("Is important?", isOn: $item.isImportant)
            
            Button("Dismiss") {
                
            }
        }
    }
}

//#Preview {
//    UpdateTodo(item: .constant())
//}

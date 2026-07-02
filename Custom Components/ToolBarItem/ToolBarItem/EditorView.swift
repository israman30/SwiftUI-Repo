//
//  EditorView.swift
//  ToolBarItem
//
//  Created by Israel Manzo on 7/2/26.
//

import SwiftUI

struct EditorView: View {
    @State var text = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            TextEditor(text: $text)
                .navigationTitle("Editor View")
                .toolbar {
                    // Cancel
                    ToolBarButton(placement: .navigationBarLeading, label: "Cancel") {
                        dismiss()
                    }
                    
                    // Save
                    ToolbarItems.saveButton(isEnabled: !text.isEmpty) {
                        print("Save: \(text)")
                        dismiss()
                    }
                }
        }
    }
}

#Preview {
    EditorView()
}

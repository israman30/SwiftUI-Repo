//
//  NewBookView.swift
//  CRUD SwiftData
//
//  Created by Israel Manzo on 2/8/25.
//

import SwiftUI

struct NewBookView: View {
    @Environment(\.dismiss) var dismiss
    @State var title: String = ""
    @State var author: String = ""
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Author", text: $author)
                Button {
                    dismiss()
                } label: {
                    Text("Create")
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                .disabled(title.isEmpty || author.isEmpty)
                .navigationTitle("New Book")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    NewBookView()
}

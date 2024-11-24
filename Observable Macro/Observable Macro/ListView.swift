//
//  ListView.swift
//  Observable Macro
//
//  Created by Israel Manzo on 11/23/24.
//

import SwiftUI

struct Book: Identifiable {
    let name: String
    let isbm: String
    
    var id: String { isbm }
}

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    
    func addBook(_ book: Book) {
        books.append(book)
    }
}

struct ListView: View {
    
    @StateObject var vm = BookViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.books) { book in
                    Text("\(book)")
                }
            }
            .navigationTitle("Books")
        }
    }
}

#Preview {
    ListView()
}

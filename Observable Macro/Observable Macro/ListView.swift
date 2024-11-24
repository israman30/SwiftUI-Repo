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
    @Published var isFavorite: Bool = false
    
    init() {
        books = [
            .init(name: "Peter Pan", isbm: "1111222"),
            .init(name: "Harry Pother", isbm: "222333"),
            .init(name: "Star Wars", isbm: "333444"),
            .init(name: "TomSawyer", isbm: "444555"),
        ]
    }
    
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
                    HStack {
                        Text("\(book.name)")
                            .padding(.vertical, 5)
                        Spacer()
                        Image(systemName: vm.isFavorite ? "star.fill" : "star")
                            .onTapGesture {
                                self.vm.isFavorite.toggle()
                            }
                    }
                }
            }
            .navigationTitle("Books")
        }
    }
}

#Preview {
    ListView()
}

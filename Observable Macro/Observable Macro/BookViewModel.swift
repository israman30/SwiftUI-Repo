//
//  BookViewModel.swift
//  Observable Macro
//
//  Created by Israel Manzo on 11/24/24.
//

import SwiftUI

struct Book: Identifiable {
    let name: String
    let isbm: String
    
    var id: String { isbm }
}

@Observable
class BookViewModel {
    var books: [Book] = []
    var isFavorite: Bool = false
    
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


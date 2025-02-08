//
//  BookListView.swift
//  CRUD SwiftData
//
//  Created by Israel Manzo on 2/8/25.
//

import SwiftUI
import SwiftData

struct BookListView: View {
    @Query(sort: \Book.title) var books: [Book]
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if books.isEmpty {
                    ContentUnavailableView("Enter a book title to search", systemImage: "book.fill")
                } else {
                    List {
                        ForEach(books) { book in
                            NavigationLink {
                                Text(book.title)
                            } label: {
                                HStack(spacing: 10) {
                                    book.icon
                                    VStack(alignment: .leading) {
                                        Text(book.title)
                                            .font(.title2)
                                        Text(book.author)
                                            .foregroundStyle(.secondary)
                                        
                                        if let rating = book.rating {
                                            HStack {
                                                ForEach(0..<rating,  id: \.self) { _ in
                                                    Image(systemName: "star.fill")
                                                        .imageScale(.small)
                                                        .foregroundStyle(.yellow)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Books")
            .toolbar {
                Button {
                    self.isPresented = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                }
            }
            .sheet(isPresented: $isPresented) {
                NewBookView()
                    .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    BookListView()
        .modelContainer(for: Book.self, inMemory: true)
}

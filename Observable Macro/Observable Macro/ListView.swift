//
//  ListView.swift
//  Observable Macro
//
//  Created by Israel Manzo on 11/23/24.
//
// https://developer.apple.com/documentation/swiftui/migrating-from-the-observable-object-protocol-to-the-observable-macro
import SwiftUI

struct ListView: View {
    
    @Environment(BookViewModel.self) var vm: BookViewModel
    @State private var isPresented: Bool = false
    
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
            .toolbar {
                Button {
                    self.isPresented.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $isPresented) {
                ChildView(book: vm)
            }
        }
    }
}

#Preview {
    ListView()
        .environment(BookViewModel())
}

struct ChildView: View {
    @Bindable var book: BookViewModel
    
    var body: some View {
        Text(book.isFavorite ? "Favorite" : "Not Favorite")
    }
}

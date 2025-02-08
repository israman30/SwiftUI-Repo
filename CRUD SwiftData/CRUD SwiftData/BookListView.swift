//
//  BookListView.swift
//  CRUD SwiftData
//
//  Created by Israel Manzo on 2/8/25.
//

import SwiftUI

struct BookListView: View {
    var body: some View {
        NavigationStack {
            VStack {
                
            }
            .navigationTitle("Books")
            .toolbar {
                Button {
                    
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                }
            }
        }
    }
}

#Preview {
    BookListView()
}

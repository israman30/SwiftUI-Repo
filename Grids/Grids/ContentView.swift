//
//  ContentView.swift
//  Grids
//
//  Created by Israel Manzo on 12/25/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var post = [
        Post(image: "person.fill", title: "Title one", body: "This is some body text for test number one", date: "12/12/2024"),
        Post(image: "person.fill", title: "Title two", body: "This is some body text for test number two", date: "12/10/2024"),
        Post(image: "person.fill", title: "Title three", body: "This is some body text for test number three", date: "12/11/2024"),
        Post(image: "person.fill", title: "Title four", body: "This is some body text for test number four", date: "12/01/2024")
    ]
    
    var body: some View {
        GridView(rows: 1, columns: 1) {
            ForEach(post, id: \.self) { post in
                VStack {
                    SomeView(post: post)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

// MARK: - Object Section
struct Post: Hashable {
    let image: String
    let title: String
    let body: String
    let date: String
}

struct SomeView: View {

    var post: Post?
    
    var body: some View {
        VStack {
            Image(systemName: post?.image ?? "")
                .resizable()
                .frame(width: 50, height: 50)
            Text(post?.title ?? "")
            Text(post?.body ?? "")
        }
        
    }
}

// Add count for column
// Add spacing
// Add data
struct GridView<Content: View>: View {
    
    let rows: Int
    let columns: Int
    let content: () -> Content
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<rows, id: \.self) { row in
                    HStack {
                        ForEach(0..<columns, id: \.self) { column in
                            content()
                        }
                    }
                }
            }
        }
    }
    
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping () -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}


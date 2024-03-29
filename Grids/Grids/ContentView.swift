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
        NavigationView {
            GridView(columns: 2) {
                ForEach(post, id: \.self) { post in
                    SomeView(post: post)
                }
            }
            .padding()
            .navigationTitle("Grid View")
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


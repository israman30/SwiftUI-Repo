//
//  ContentView.swift
//  AppStateResult
//
//  Created by Israel Manzo on 6/25/26.
// https://jsonplaceholder.typicode.com/posts
/**
 "userId": 1,
 "id": 1,
 "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
 "body":
 */

struct User: Decodable {
    let id: Int
    let title: String
    let body: String
}



import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

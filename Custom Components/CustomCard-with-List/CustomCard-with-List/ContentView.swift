//
//  ContentView.swift
//  CustomCard-with-List
//
//  Created by Israel Manzo on 5/15/22.
//

import SwiftUI

struct Post: Hashable {
    let image: String
    let title: String
    let body: String
    let date: String
}

struct ContentView: View {
    var body: some View {
        MainView()
    }
}

struct MainView: View {
    
    @State var post = [
            Post(image: "world", title: "Title one", body: "This is some body text for test number one", date: "12/12/2024"),
            Post(image: "world", title: "Title two", body: "This is some body text for test number two", date: "12/10/2024"),
            Post(image: "world", title: "Title three", body: "This is some body text for test number three", date: "12/11/2024"),
            Post(image: "world", title: "Title four", body: "This is some body text for test number four", date: "12/01/2024")
        ]
    
    var body: some View {
        VStack {
            Text("Custom Card")
                .font(.title3)
                .fontWeight(.bold)
            List(post, id: \.self) { post in
                CustomCardView(content: post)
            }.listStyle(.grouped)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//
//  ContentView.swift
//  CustomCard-with-List
//
//  Created by Israel Manzo on 5/15/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainView()
    }
}

struct MainView: View {
    var body: some View {
        VStack {
            Text("Custom Card")
                .font(.title3)
                .fontWeight(.bold)
            List(0..<5) { _ in
                CustomCardView()
            }.listStyle(.grouped)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


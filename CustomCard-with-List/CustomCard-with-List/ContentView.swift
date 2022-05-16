//
//  ContentView.swift
//  CustomCard-with-List
//
//  Created by Israel Manzo on 5/15/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CustomCardView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct CustomCardView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Super Mario Bros.")
                Text("Mario")
            }
        }
    }
}

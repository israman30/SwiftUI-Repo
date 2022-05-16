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
        VStack(alignment: .leading) {
            Image("world")
                .resizable()
                .aspectRatio(contentMode: .fit)
            VStack(alignment: .leading) {
                Text("Super Mario Bros.")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Explore the adventure of Mario's world")
                    .foregroundColor(Color(.systemGray))
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
        .background(Color.white)
        .shadow(radius: 1.5)
    }
}

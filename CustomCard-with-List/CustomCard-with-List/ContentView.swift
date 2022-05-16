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
            Text("Custom Card")
                .font(.title3)
                .fontWeight(.bold)
            CustomCardView()
                .padding()
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
        .cornerRadius(5)
        .shadow(color: Color.gray, radius: 5, x: 0, y: 2)
    }
}

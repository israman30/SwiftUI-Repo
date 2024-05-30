//
//  ContentView.swift
//  Text Styles
//
//  Created by Israel Manzo on 5/29/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
            Text("Some Text styles")
                .font(.largeTitle)
            Spacer()
            Text("**Bold Text**")
            Text("*Italic Text*")
            Text("_Italic Text also_")
            Text("~~strikethrough text~~")
            Text("[My GitHub Repo Link](https://github.com/israman30/SwiftUI-Repo)")
            Text("This web site is using  `your code here`")
            Text("~~*italic strikethrough*~~")
            Spacer()
        }
        .font(.title3)
        .padding()
    }
}

#Preview {
    ContentView()
}

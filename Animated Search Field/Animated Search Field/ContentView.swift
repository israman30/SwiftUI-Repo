//
//  ContentView.swift
//  Animated Search Field
//
//  Created by Israel Manzo on 12/10/24.
//

import SwiftUI

struct ContentView: View {
    @State var labels: [String] = ["'Food'", "'Restaurants'", "'Groceries'", "'Beverages'", "'Bread'", "'Pizza'", "'Biryani'", "'Burger'", "'Bajji'", "'Noodles'", "'Soup'", "'Sandwich'", "'Biscuits'", "'Chocolates'"]
    @State var currentIndex: Int = 0
    @State var currentLabel: String = "'Food'"
    @State var nextLabel: String = "'Restaurants'"
    @State var currentOpacity: Double = 1
    @State var nextOpacity: Double = 0
    @State private var currentOffset: CGFloat = 0
    @State private var nextOffset: CGFloat = 20
    @State private var timer: Timer? = nil
    
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

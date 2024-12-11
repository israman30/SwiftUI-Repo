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
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                    .padding(.leading, 10)
                ZStack(alignment: .leading) {
                    HStack {
                        Group {
                            Text("Search for")
                            
                            ZStack(alignment: .leading) {
                                Text(currentLabel)
                                    .opacity(currentOpacity)
                                    .offset(y: currentOffset)
                                Text(nextLabel)
                                    .opacity(nextOpacity)
                                    .offset(y: nextOffset)
                            }
                            .onAppear {
                                animateLabels()
                            }
                        }
                        .foregroundStyle(.gray)
                        Spacer()
                    }
                }
            }
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func resumeTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
            updateLabels()
        })
    }
    
    func animateLabels() {
        currentLabel = labels[currentIndex]
        nextLabel = labels[(currentIndex + 1) % labels.count]
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
            updateLabels()
        })
    }
    
    func updateLabels() {
        withAnimation(.easeInOut(duration: 1.0)) {
            currentOpacity = 0
            currentOffset = -20
            nextOpacity = 1
            nextOffset = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            currentLabel = nextLabel
            currentOpacity = 1
            currentOffset = 0
            nextOpacity = 0
            nextOffset = 20
            currentIndex = (currentIndex + 1) % labels.count
            nextLabel = labels[(currentIndex + 1) % labels.count]
        }
    }
}

#Preview {
    ContentView()
}

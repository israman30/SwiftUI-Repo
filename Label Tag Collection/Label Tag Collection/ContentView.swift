//
//  ContentView.swift
//  Label Tag Collection
//
//  Created by Israel Manzo on 11/9/24.
//

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

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct TagCollectionView<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    let data: Data
    let spacing: CGFloat
    let singleItemHeight: CGFloat
    let content: (Data.Element) -> Content
    @State private var totalHeight: CGFloat = .zero
    
    init(data: Data, spacing: CGFloat = 10, singleItemHeight: CGFloat = 100, @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.spacing = spacing
        self.singleItemHeight = singleItemHeight
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { proxy in
                generateContent(for: proxy)
                    .background(
                        GeometryReader { proxy in
                            Color.clear.preference(key: HeightPreferenceKey.self, value: proxy.size.height)
                        }
                    )
            }
        }
        .onPreferenceChange(HeightPreferenceKey.self) { height in
            totalHeight = height
        }
        .frame(height: totalHeight)
    }
    
    private func generateContent(for proxy: GeometryProxy) -> some View {
        var width: CGFloat = .zero
        var height: CGFloat = .zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(data) { item in
                content(item)
                    .alignmentGuide(.leading) { dimensions in
                        if abs(width - dimensions.width) > proxy.size.width {
                            width = 0
                            height -= dimensions.height + spacing
                        }
                        let result = width
                        if item.id == data.last?.id {
                            width = 0
                        } else {
                            width -= dimensions.width + spacing
                        }
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = height
                        if item.id == data.last?.id {
                            height = 0
                        }
                        return result
                    }
            }
        }
        
    }
}

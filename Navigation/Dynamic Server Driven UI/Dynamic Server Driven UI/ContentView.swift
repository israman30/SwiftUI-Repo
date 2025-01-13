//
//  ContentView.swift
//  Dynamic Server Driven UI
//
//  Created by Israel Manzo on 1/13/25.
//

import SwiftUI

struct UIComponent: Codable {
    let type: String
    let alignment: String?
    let spacon: String?
    let text: String?
    let title: String?
    let action: String?
    let children: [UIComponent]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case alignment
        case spacon
        case text
        case title
        case action
        case children
    }
}

// Example JSON response
let jsonData = """
{
  "type": "vstack",
  "alignment": "leading",
  "spacing": 10,
  "children": [
    {
      "type": "text",
      "text": "Dynamic Parsing with Codable"
    },
    {
      "type": "button",
      "title": "Get Started",
      "action": "startAction"
    }
  ]
}
""".data(using: .utf8)!

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

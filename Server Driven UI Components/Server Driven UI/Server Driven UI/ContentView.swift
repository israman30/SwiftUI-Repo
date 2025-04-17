//
//  ContentView.swift
//  Server Driven UI
//
//  Created by Israel Manzo on 4/17/25.
//

import SwiftUI

/**
 {
 "type": "vstack",
 "alignment": "leading",
 "spacing": 10,
 "children": [
   {
     "type": "text",
     "text": "Welcome to Server-Driven UI"
   },
   {
     "type": "button",
     "title": "Click Me",
     "action": "buttonClicked"
   }
 ]
}
 */

struct UIComponent: Codable {
    let type: String
    let alignment: String?
    let spacing: Int?
    let text: String?
    let title: String?
    let action: String?
    let children: [UIComponent]?
    enum CodingKeys: String, CodingKey {
        case type
        case alignment
        case spacing
        case text
        case title
        case action
        case children
    }
}

// Modularize Your UI Components
struct TextComponent: View {
    var text: String
    var body: some View {
        Text(text)
    }
}

struct ButtonComponent: View {
    var title: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
        }
    }
}

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

// Implement a Flexible UI Builder
struct UIBuilder {
    static func build(_ component: UIComponent) -> some View {
        switch component.type {
            case "text":
            return AnyView(TextComponent(text: component.text ?? ""))
        case "button":
            return AnyView(ButtonComponent(title: component.title ?? "", action: {
                // action
            }))
        case "vstack":
            let childreViews = (component.children ?? []).map { build($0) }
            return AnyView(VStack(alignment: .leading, spacing: CGFloat(component.spacing ?? 0)) {
                ForEach(0..<childreViews.count, id: \.self) { child in
                    childreViews[child]
                }
            })
        default:
            return AnyView(EmptyView())
        }
    }
}

// Handle Dynamic Data Efficiently
struct DynamicContentView: View {
    @State var components: [UIComponent] = []
    var body: some View {
        VStack {
            ForEach(components, id: \.type) { component in
                UIBuilder.build(component)
            }
        }
        .padding()
        .onAppear {
            fetchData()
        }
    }
    
    func fetchData() {
        // fetch ui data
    }
}

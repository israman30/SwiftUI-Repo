//
//  ContentView.swift
//  Dynamic Server Driven UI
//
//  Created by Israel Manzo on 1/13/25.
//

import SwiftUI

struct UIComponent: Codable, Hashable {
    var type: String
    var alignment: String? = nil
    var spacing: Int? = nil
    var text: String? = nil
    var title: String? = nil
    var action: String? = nil
    var children: [UIComponent]? = nil
    
    enum CodingKeys: String, CodingKey {
        case type
        case alignment
        case spacing
        case text
        case title
        case action
        case children
    }
    
    init(type: String, alignment: String? = nil , spacing: Int? = nil, text: String? = nil, title: String? = nil, action: String? = nil, children: [UIComponent]? = nil) {
        self.type = type
        self.alignment = alignment
        self.spacing = spacing
        self.text = text
        self.title = title
        self.action = action
        self.children = children
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

var object: UIComponent!

func fetchUI() {
    do {
        let parsedComponent = try JSONDecoder().decode(UIComponent.self, from: jsonData)
        print(parsedComponent)
        object.type = parsedComponent.type
    } catch {
        print("Failed to parse JSON: \(error)")
    }
}



struct ContentView: View {
    @State var uiComponent: UIComponent?
    
    var body: some View {
        VStack {
            TextViewCompononet(text: "Welcome to Modular UI")
            ButtonComponent(title: "Get Started") {
                print("Button Tapped!")
            }
            ExampleView(uiView: UIComponent(type: "text", alignment: "15", spacing: 10, text: "UI Component", title: "Some Title", action: "", children: nil))
            
            CustomComponent()
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

// Reusable Button Component
struct TextViewCompononet: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.body)
            .foregroundStyle(.primary)
    }
}

// Reusable Button Component
struct ButtonComponent: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

struct UIBuilderComponent {
    
    static func buildUI(from uiComponent: UIComponent) -> some View {
        switch uiComponent.type {
            case "text":
            return AnyView(TextViewCompononet(text: uiComponent.text ?? ""))
        case "button":
            return AnyView(ButtonComponent(title: uiComponent.title ?? "", action: {
                print("Some action!")
            }))
        case "vstack":
            let childrendViews = (uiComponent.children ?? []).map { buildUI(from: $0) }
            return AnyView(VStack(alignment: .leading, spacing: CGFloat( uiComponent.spacing ?? 10), content: {
                ForEach(0..<childrendViews.count, id: \.self) { index in
                    childrendViews[index]
                }
            }))
        default:
            return AnyView(EmptyView())
        }
    }
}

struct ExampleView: View {
    let uiView: UIComponent
    
    var body: some View {
        UIBuilderComponent.buildUI(from: uiView)
    }
}

struct CustomComponent: View {
    @State var components: [UIComponent] = []
    
    var body: some View {
        List(components.indices, id: \.self) { index in
            UIBuilderComponent.buildUI(from: components[index])
        }
        .onAppear {
            fetchData()
        }
    }
    
    func fetchData() {
        self.components = [
            UIComponent(type: "text", text: "Dynamic UI Update"),
            UIComponent(type: "button", title: "Refresh", action: "refreshAction"),
            UIComponent(type: "vstack", text: "hello"),
        ]
        
    }
}

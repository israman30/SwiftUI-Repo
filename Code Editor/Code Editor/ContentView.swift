//
//  ContentView.swift
//  Code Editor
//
//  Created by Israel Manzo on 3/29/25.
//

import SwiftUI

struct ContentView: View {
    @State var text: String = """
    struct Member {
            let id = UUID().uuidString
            var name: String
            var team: Team
        }
        
    enum Team {
        case home, away
        
        var color: Color {
            switch self {
            case .home: return .red
            case .away: return .blue
            }
        }
    }
    """
    var body: some View {
        CodeEditor(text: $text, theme: .default)
    }
}

#Preview {
    ContentView()
}

//
//  EditorTheme.swift
//  Code Editor
//
//  Created by Israel Manzo on 3/29/25.
//

import AppKit

struct EditorTheme {
    var id = UUID()
    var name: String
    var font: NSFont = .monospacedSystemFont(ofSize: 12, weight: .regular)
    
    var syntaxOptions: [SyntaxOption]
    var backgroundColor: NSColor = .textBackgroundColor
    
    static var `default`: EditorTheme {
        .init(name: "Default", syntaxOptions: SyntaxOption.default)
    }
}

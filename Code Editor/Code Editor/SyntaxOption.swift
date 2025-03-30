//
//  SyntaxOption.swift
//  Code Editor
//
//  Created by Israel Manzo on 3/29/25.
//

import AppKit

struct SyntaxOption {
    var word: String
    var color: NSColor
    var font: NSFont = .monospacedSystemFont(ofSize: 12, weight: .regular)
    
    static var `default`: [SyntaxOption] {
        return [
            // Keywords
            SyntaxOption(word: "struct", color: .systemBlue),
            SyntaxOption(word: "class", color: .systemBlue),
            SyntaxOption(word: "enum", color: .systemBlue),
            SyntaxOption(word: "static", color: .systemPink),
            SyntaxOption(word: "func", color: .systemPink),
            SyntaxOption(word: "case", color: .systemPink),
            SyntaxOption(word: "mutating", color: .systemPink),
            SyntaxOption(word: "nonmutating", color: .systemPink),
            SyntaxOption(word: "let", color: .systemPink),
            SyntaxOption(word: "var", color: .systemPink),
            SyntaxOption(word: "return", color: .systemPink),
            SyntaxOption(word: "protocol", color: .systemPink),
            SyntaxOption(word: "extension", color: .systemPink),
            SyntaxOption(word: "private", color: .systemPink),
            SyntaxOption(word: "public", color: .systemPink),
            SyntaxOption(word: "internal", color: .systemPink),
            
            // Types
            SyntaxOption(word: "Int", color: .systemPink),
            SyntaxOption(word: "String", color: .systemPink),
            SyntaxOption(word: "Bool", color: .systemPink),
            SyntaxOption(word: "Double", color: .systemPink),
            SyntaxOption(word: "Float", color: .systemPink),
            
            // Constants
            SyntaxOption(word: "true", color: .systemPink),
            SyntaxOption(word: "false", color: .systemPink),
            SyntaxOption(word: "nil", color: .systemPink),
            
            // Compiler Directives
            SyntaxOption(word: "#if", color: .systemOrange),
            SyntaxOption(word: "#else", color: .systemOrange),
            SyntaxOption(word: "#endif", color: .systemOrange),
            
            // Protocols
            SyntaxOption(word: "Identifiable", color: .systemPink),
            SyntaxOption(word: "Hashable", color: .systemPink),
            SyntaxOption(word: "Equatable", color: .systemPink),
            SyntaxOption(word: "Codable", color: .systemPink),
            SyntaxOption(word: "Encodable", color: .systemPink),
            SyntaxOption(word: "Decodable", color: .systemPink)
        ]
    }
}



//
//  CodeEditor.swift
//  Code Editor
//
//  Created by Israel Manzo on 3/29/25.
//

import SwiftUI

struct CodeEditor: NSViewRepresentable {
    @Binding var text: String
    var theme: EditorTheme
    var padding: CGFloat = 12
    
    @State var textView: NSTextView?
    
    func makeNSView(context: Context) -> NSView {
        let view = NSTextView.scrollableTextView()
        guard let textView = view.documentView as? NSTextView else { return view }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.textView = textView
            configureTextView(context)
        }
        view.contentInsets = .init(top: padding, left: padding, bottom: padding, right: padding)
        view.automaticallyAdjustsContentInsets = false
        return view
    }
    
    func configureTextView(_ context: Context) {
        textView?.font = theme.font
        textView?.isEditable = true
        textView?.isRichText = false
        textView?.backgroundColor = theme.backgroundColor
        textView?.delegate = context.coordinator
    }
    
    func applySyntaxStyling() {
        let attributedString = NSMutableAttributedString(string: text)
        
        let fullRange = NSRange(location: 0, length: text.utf8.count)
        
        // Default styling for the text.
        attributedString.addAttribute(.font, value: theme.font, range: fullRange)
        attributedString.addAttribute(.foregroundColor, value: NSColor.labelColor, range: fullRange)
        
        // Apply styling for the text that matches the a SyntaxOption object.
        for option in theme.syntaxOptions {
            let regex = try? NSRegularExpression(pattern: "\\b\(NSRegularExpression.escapedPattern(for: option.word))\\b", options: .caseInsensitive)
            let matches = regex?.matches(in: text, options: [], range: fullRange) ?? []
            
            for match in matches {
                attributedString.addAttribute(.foregroundColor, value: option.color, range: match.range)
                attributedString.addAttribute(.font, value: option.font, range: match.range)
            }
        }
        
        textView?.textStorage?.setAttributedString(attributedString)
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        applySyntaxStyling()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: CodeEditor
        var textView: NSTextView?
        
        
        init(_ parent: CodeEditor) {
            self.parent = parent
            self.textView = parent.textView
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            DispatchQueue.main.async {
                self.parent.text = textView.string
            }
        }
    }
}

//#Preview {
//    CodeEditor(text: .constant("text"))
//}

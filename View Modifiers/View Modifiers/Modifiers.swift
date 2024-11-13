//
//  Modifiers.swift
//  View Modifiers
//
//  Created by Israel Manzo on 11/12/24.
//

import SwiftUI

// MARK: - Heading Modifier -
struct Heading1: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Baloo2-ExtraBold", size: 24))
    }
}

extension View {
    public func heading1() -> some View {
        modifier(Heading1())
    }
}

// MARK: - Card Shadow Modifer -
struct CardShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.16), radius: 12)
    }
}

extension View {
    public func cardShadow() -> some View {
        modifier(CardShadow())
    }
}

// MARK: - Layout Modifer -
struct AlignModifier: ViewModifier {
    let alignment: Alignment
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}

struct AlignTextModifier: ViewModifier {
    let alignment: Alignment
    let textAlignment: TextAlignment
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: alignment)
            .multilineTextAlignment(textAlignment)
    }
}

extension View {
    func alignView(_ alignment: Alignment) -> some View {
        modifier(AlignModifier(alignment: alignment))
    }
    
    func alignText(_ alignment: Alignment, textAlignment: TextAlignment) -> some View {
        modifier(AlignTextModifier(alignment: alignment, textAlignment: textAlignment))
    }
    
    func fullWidth() -> some View {
        frame(maxWidth: .infinity)
    }
}

// MARK: - `if` modifier
extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: @autoclosure() -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}

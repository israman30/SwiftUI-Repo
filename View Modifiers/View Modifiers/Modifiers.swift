//
//  Modifiers.swift
//  View Modifiers
//
//  Created by Israel Manzo on 11/12/24.
//

import SwiftUI

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

//
//  PrebuildItems.swift
//  ToolBarItem
//
//  Created by Israel Manzo on 7/2/26.
//

import SwiftUI

// MARK: - Common Toolbar Items
struct ToolbarItems {
    // MARK: - Back Button
    static func backButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolBarButton(placement: .navigationBarLeading, icon: "chevron.left", label: "Back", action: action)
    }
    
    // MARK: - Close Button
    static func closeButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolBarButton(placement: .navigationBarLeading, icon: "xmark", action: action)
    }
}

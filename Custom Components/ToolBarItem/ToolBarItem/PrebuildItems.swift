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
        ToolBarButton(placement: .navigationBarTrailing, icon: "xmark", action: action)
    }
    
    // MARK: - Add Button
    static func addButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolBarButton(placement: .navigationBarTrailing, icon: "plus", action: action)
    }
    
    // MARK: - Share Button
    static func shareButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolBarButton(placement: .navigationBarTrailing, icon: "square.and.arrow.up", label: "Share", action: action)
    }
    
    // MARK: - Settings Button
    static func settingsButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolBarButton(placement: .navigationBarTrailing, icon: "gearshape.fill", action: action)
    }
    
    // MARK: - Save Button
    static func saveButton(isEnabled: Bool = true, action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save", action: action)
                .disabled(!isEnabled)
        }
    }
    
    // MARK: - Delete Button
    static func deleteButton(isEnabled: Bool = true, action: @escaping () -> Void) -> some ToolbarContent {
        ToolBarButton(placement: .navigationBarTrailing, icon: "trash", action: action)
    }
}

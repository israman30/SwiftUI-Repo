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
    
    // MARK: - More Menu
    static func moreMenu(content: @escaping () -> some View) -> some ToolbarContent {
        ToolBarMenu(.navigationBarTrailing, icon: "ellipsis.circle", menuContent: content)
    }
    
    // MARK: - Help Button
    static func helpButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolBarButton(placement: .navigationBarTrailing, icon: "questionmark.circle", action: action)
    }
    
    // MARK: - Refresh Button
    static func refreshButton(isLoading: Bool = false, action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if isLoading {
                ProgressView()
                    .scaleEffect(0.8)
            } else {
                Button {
                    action()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
    
    // MARK: - Filter Button
    static func filterButton(isActive: Bool = false, action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                action()
            } label: {
                Image(systemName: isActive ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
            }
        }
    }
    
    // MARK: - Sort Button
    static func sortButton(isActive: Bool = false, action: @escaping () -> Void) -> some ToolbarContent {
        ToolBarButton(placement: .navigationBarTrailing, icon: "arrow.up.arrow.down.circle", action: action)
    }
    
    // MARK: - Notifications Badge
    static func notificationsBadge(count: Int, action: @escaping () -> Void) -> some ToolbarContent {
        ToolBarBadge(.navigationBarTrailing, icon: "bell.fill", badgeCount: count, action: action)
    }
}

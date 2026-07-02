//
//  ToolBarItemComponent.swift
//  ToolBarItem
//
//  Created by Israel Manzo on 7/2/26.
//

import SwiftUI

// MARK: - Toolbar Item Placement
enum ToolbarPlacement {
    case navigationBarLeading
    case navigationBarTrailing
    case navigationBarBotton
    case keyboard
    case status
}

// MARK: - Toolbar Button Style
enum ToolBarButtonStyle {
    case icon
    case text
    case iconAndText
    case custom
}

// MARK: - Reusable Toolbar Item
struct ToolbarItemBuilder<Content: View>: ToolbarContent {
    let placement: ToolbarItemPlacement
    let content: () -> Content
    
    init(placement: ToolbarItemPlacement, @ViewBuilder content: @escaping () -> Content) {
        self.placement = placement
        self.content = content
    }
    
    var body: some ToolbarContent {
        ToolbarItem(placement: placement, content: content)
    }
}

// MARK: - Convenience Builders
struct ToolBarButton: ToolbarContent {
    let placement: ToolbarItemPlacement
    let icon: String?
    let label: String?
    let action: () -> Void
    init(placement: ToolbarItemPlacement, icon: String? = nil, label: String? = nil, action: @escaping () -> Void) {
        self.placement = placement
        self.icon = icon
        self.label = label
        self.action = action
    }
    
    var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            Button(action: action) {
                if let icon = icon, let label = label {
                    Label(label, systemImage: icon)
                } else if let icon = icon {
                    Image(systemName: icon)
                } else if let label = label {
                    Text(label)
                }
            }
        }
    }
}

// MARK: - Menu Toolbar Item
struct ToolBarMenu<MenuContent: View>: ToolbarContent {
    let placement: ToolbarItemPlacement
    let icon: String
    let label: String
    let menuContent: () -> MenuContent
    
    init(_ placement: ToolbarItemPlacement, icon: String, label: String = "More", @ViewBuilder menuContent: @escaping () -> MenuContent) {
        self.placement = placement
        self.icon = icon
        self.label = label
        self.menuContent = menuContent
    }
    
    var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            Menu {
                menuContent()
            } label: {
                Label(label, systemImage: icon)
            }
        }
    }
}

// MARK: - Search Toolbar Item
struct ToolBarSearchField: ToolbarContent {
    let placement: ToolbarItemPlacement
    @Binding var searchText: String
    let placeholder: String
    
    init(_ placement: ToolbarItemPlacement = .navigationBarTrailing, text: Binding<String>, placeholder: String = "Search") {
        self.placement = placement
        self._searchText = text
        self.placeholder = placeholder
    }
    
    var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField(placeholder, text: $searchText)
                if searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

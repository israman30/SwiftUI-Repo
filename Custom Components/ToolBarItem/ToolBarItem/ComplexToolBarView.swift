//
//  ComplexToolBarView.swift
//  ToolBarItem
//
//  Created by Israel Manzo on 7/2/26.
//

import SwiftUI

struct ComplexToolBarView: View {
    @State var searchText = ""
    @State var isEditing = false
    @State var isLoading = false
    @State var isFilterActive = false
    
    var body: some View {
        NavigationStack {
            List(1...10, id: \.self) { i in
                Text("Item: \(i)")
            }
            .navigationTitle("Complex Toolbar")
            .toolbar {
                // Leading
                ToolbarItems.backButton {
                    print("Back")
                }
                
                // Trailing - Multiple Items
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        if !isEditing {
                            Button {
                                isEditing.toggle()
                            } label: {
                                Image(systemName: "magnifyingglass")
                            }
                        }
                        
                        // Filter
                        Button {
                            isFilterActive.toggle()
                        } label: {
                            Image(systemName: isFilterActive ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                        }
                        
                        // More
                        Menu {
                            Button("Refresh") {
                                print("Refresh")
                            }
                            Button("Share") {
                                print("Share")
                            }
                            Button("Settings") {
                                print("Settings")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ComplexToolBarView()
}

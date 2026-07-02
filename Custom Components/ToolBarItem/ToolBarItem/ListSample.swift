//
//  ListSample.swift
//  ToolBarItem
//
//  Created by Israel Manzo on 7/2/26.
//

import SwiftUI

struct ListSample: View {
    @State var isEditing = false
    @State var searchText = ""
    
    var body: some View {
        NavigationStack {
            List(0..<20) { item in
                Text("Number: \(item)")
            }
            .navigationTitle("Smaple")
            .toolbar {
                ToolbarItems.addButton {
                    print("Add number")
                }
                
                ToolBarEditingToggle(.navigationBarLeading, isEditing: $isEditing)
                
                ToolBarSearchField(.navigationBarTrailing, text: $searchText)
            }
        }
    }
}

#Preview {
    ListSample()
}

//
//  DetailMenuView.swift
//  ToolBarItem
//
//  Created by Israel Manzo on 7/2/26.
//

import SwiftUI

struct DetailMenuView: View {
    @State var isFavorite = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack {
                Text("John Doe")
                    .font(.title)
                Text("John is the coolest guy that I know.")
                    .font(.body)
            }
            .navigationTitle("Detail")
            .toolbar {
                // Back button
                ToolbarItems.backButton {
                    dismiss()
                }
                
                // More menu
//                ToolbarItems.moreMenu {
//                    Button("Share") {
//                        print("Share")
//                    }
//                    Button("Copy") {
//                        print("Copy")
//                    }
//                    Button("Bookmark") {
//                        print("Bookmark")
//                    }
//                    Divider()
//                    Button("Report", role: .destructive) {
//                        print("Report")
//                    }
//                }
            }
        }
    }
}

#Preview {
    DetailMenuView()
}

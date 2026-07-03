//
//  IndoxView.swift
//  ToolBarItem
//
//  Created by Israel Manzo on 7/2/26.
//

import SwiftUI

struct IndoxView: View {
    @State var messages = 12
    var body: some View {
        NavigationStack {
            List(1...5, id: \.self) { i in
                Text("\(i) - Message")
            }
            .navigationTitle("Inbox")
            .toolbar {
                ToolbarItems.notificationsBadge(count: messages) {
                    print("Clear notification")
                    messages = 0
                }
            }
        }
    }
}

#Preview {
    IndoxView()
}

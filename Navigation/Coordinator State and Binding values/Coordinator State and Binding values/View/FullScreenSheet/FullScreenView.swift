//
//  FullScreenView.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/24/24.
//

import SwiftUI

struct FullScreenView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        List {
            Text("This is a full screen view!")
                .font(.headline)
            
            Button {
                coordinator.dismissFullScren()
            } label: {
                Text("Dismiss")
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    FullScreenView()
        .environmentObject(Coordinator())
}

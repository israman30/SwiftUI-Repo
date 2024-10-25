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
            
            Button("Other Page") {
                
            }
        }
    }
}

#Preview {
    FullScreenView()
        .environmentObject(Coordinator())
}

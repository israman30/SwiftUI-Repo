//
//  SecondPageView.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/24/24.
//

import SwiftUI

struct SecondPageView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        VStack {
            Text("This is a second page!")
                .font(.title)
            
            Button {
                coordinator.popToRoot()
            } label: {
                Text("Go to Main Page")
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    SecondPageView()
}

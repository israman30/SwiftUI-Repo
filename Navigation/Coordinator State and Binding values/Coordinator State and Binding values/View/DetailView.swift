//
//  DetailView.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

struct DetailView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        VStack {
            Text("This is the detail view")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button {
                coordinator.push(.secondPage)
            } label: {
                Text("Go to Secong Page")
            }
            .buttonStyle(.borderedProminent)
            
        }
    }
}

#Preview {
    DetailView()
}

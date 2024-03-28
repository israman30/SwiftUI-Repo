//
//  HomeView.swift
//  Authentication
//
//  Created by Israel Manzo on 3/28/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Info text")
                .multilineTextAlignment(.center)
                .font(.callout)
            
            Button("Fetch Data") {
                
            }
            
            Button("Reset") {
                
            }
            
            Button("Logout") {
                
            }
        }
        .navigationTitle("Home")
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    HomeView()
}

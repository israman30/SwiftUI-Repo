//
//  HomeView.swift
//  Authentication
//
//  Created by Israel Manzo on 3/28/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm: ViewModel
    
    var body: some View {
        VStack {
            Text(vm.infoText)
                .multilineTextAlignment(.center)
                .font(.callout)
            
            Button("Fetch Data") {
                vm.fetchSecureDate()
            }
            
            Button("Reset") {
                vm.resetInfoText()
            }
            
            Button("Logout") {
                vm.logout()
            }
        }
        .navigationTitle("Home")
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    HomeView(vm: .init())
}

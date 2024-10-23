//
//  ContentView.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var myViewModel: MyViewModel
    
    var body: some View {
        CoordinatorView()
    }
}

#Preview {
    ContentView()
        .environmentObject(Coordinator())
        .environmentObject(MyViewModel())
}

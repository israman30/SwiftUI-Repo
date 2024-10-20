//
//  ContentView.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        CoordinatorView()
    }
}

#Preview {
    ContentView()
        .environmentObject(Coordinator())
}

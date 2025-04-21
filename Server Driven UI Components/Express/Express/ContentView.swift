//
//  ContentView.swift
//  Express
//
//  Created by Israel Manzo on 4/17/25.
//

/**
`Architecture`
Server -> JSON -> UI Models -> Components -> View
 */

import SwiftUI

struct ContentView: View {
    
    @StateObject var vm = UIListViewModel(networkManager: NetworkManager())
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(vm.compoennts, id: \.uniqueID) { component in
                    component.render()
                }
                .navigationTitle("UI Component")
            }
            .task {
                await vm.fetchUIList()
            }
        }
    }
}

#Preview {
    ContentView()
}

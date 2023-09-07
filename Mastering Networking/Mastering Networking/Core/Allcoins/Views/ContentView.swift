//
//  ContentView.swift
//  Mastering Networking
//
//  Created by Israel Manzo on 9/6/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var vm = CoinsViewModel()
    
    var body: some View {
        List {
            ForEach(vm.coins) { coin in
                Text(coin.name)
            }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

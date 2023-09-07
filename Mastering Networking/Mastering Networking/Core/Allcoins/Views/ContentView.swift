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
        VStack {
            Text("\(vm.coins) : \(vm.price)")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

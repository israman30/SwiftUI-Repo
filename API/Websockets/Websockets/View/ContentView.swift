//
//  ContentView.swift
//  Websockets
//
//  Created by Israel Manzo on 5/4/26.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
        NavigationStack {
            ChatView(viewModel: viewModel)
                .navigationTitle("Chat")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

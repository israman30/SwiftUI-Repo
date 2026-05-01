//
//  ContentView.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI

/// Root view of the sample. Delegates to the Posts list screen.
struct ContentView: View {
    var body: some View {
        PostListView()
    }
}

#Preview {
    ContentView()
}

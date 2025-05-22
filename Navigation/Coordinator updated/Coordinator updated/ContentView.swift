//
//  ContentView.swift
//  Coordinator updated
//
//  Created by Israel Manzo on 5/21/25.
//

import SwiftUI

// MARK: - Coordinatable
typealias Coordinatable = View & Identifiable & Hashable

// MARK: - Coordinator
@Observable
class Coordinator<CoordinatorPage: Coordinatable> {
    @State var path = NavigationPath()
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

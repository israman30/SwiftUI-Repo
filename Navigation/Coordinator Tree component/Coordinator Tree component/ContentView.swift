//
//  ContentView.swift
//  Coordinator Tree component
//
//  Created by Israel Manzo on 1/10/25.
//

import SwiftUI

/**
             `Profile coordinator -> Detail`
            `/`
 `Tab Coordinator -> Wallet Coordinator -> Wallet detail`
           ` \`
             `Item Coordinator -> Item detail`
                                  ` \`
                                     `Payment coordinator -> Select item -> Add to cart -> Buy item -> Summary`
 */

// MARK: - Understanding the Coordinator Pattern
/// The `Coordinator` Pattern is a design methodology that streamlines and oversees the navigation flow within an application. It helps maintain a clean codebase by segregating navigation logic, allowing views to concentrate on their individual responsibilities.

struct ContentView: View {
    var body: some View {
        HomeView()
    }
}

#Preview {
    ContentView()
}

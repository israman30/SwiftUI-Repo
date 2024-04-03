//
//  HomeView.swift
//  Router Pattern Navigation
//
//  Created by Israel Manzo on 4/3/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack {
            RouterView {
                ViewA()
            }
        }
    }
}

#Preview {
    Home()
}

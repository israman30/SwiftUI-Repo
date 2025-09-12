//
//  Views.swift
//  Router Pattern Navigation
//
//  Created by Israel Manzo on 4/3/24.
//

import SwiftUI

struct ViewA: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack() {
            Button("Go to View B") {
                router.navigate(to: .viewB("Got here from A"))
            }
            Button("Go to View C") {
                router.navigate(to: .viewC)
            }
        }
        .navigationTitle("View A")
    }
}
struct ViewB: View {
    
    @EnvironmentObject var router: Router
    
    let description: String
    
    var body: some View {
        VStack() {
            Text(description)
            Button("Go to View A") {
                router.navigate(to: .viewA)
            }
            Button("Go to View C") {
                router.navigate(to: .viewC)
            }
        }
        .navigationTitle("View B")
    }
}

struct ViewC: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack() {
            Button("Go to View B") {
                router.navigate(to: .viewB("Got here from C"))
            }
            Button("Go back") {
                router.navigateBack()
            }
        }
        .navigationTitle("View C")
    }
}

#Preview {
    ViewA()
}

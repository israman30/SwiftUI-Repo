//
//  CoordinatorView.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

struct CoordinatorView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var myViewModel: MyViewModel
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(.home, myViewModel: myViewModel)
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page, myViewModel: myViewModel)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.build(sheet: sheet, myViewModel: myViewModel)
                }
                .fullScreenCover(item: $coordinator.fullScreen) { sheet in
                    coordinator.build(fullScreen: sheet, myViewModel: myViewModel)
                }
        }
        .environmentObject(coordinator)
    }
}

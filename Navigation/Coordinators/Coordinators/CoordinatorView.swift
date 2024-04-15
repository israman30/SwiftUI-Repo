//
//  CoordinatorView.swift
//  Coordinators
//
//  Created by Israel Manzo on 4/14/24.
//

import SwiftUI

struct CoordinatorView: View {
    
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(.main)
                .navigationDestination(for: Pages.self) { page in
                    coordinator.build(page)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.build(sheet)
                }
                .fullScreenCover(item: $coordinator.fullScreenSheet) { fullScreenSheet in
                    coordinator.build(fullScreenSheet)
                }
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    CoordinatorView()
}

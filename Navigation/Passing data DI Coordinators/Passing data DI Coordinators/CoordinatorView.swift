//
//  CoordinatorView.swift
//  Passing data DI Coordinators
//
//  Created by Israel Manzo on 4/19/24.
//

import SwiftUI

struct CoordinatorView: View {
    
    @StateObject var coordinator = Coordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(.main)
                .navigationDestination(for: Pages.self) { page in
                    coordinator.build(page)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.present(sheet)
                }
        }
        .environmentObject(coordinator)
    }
        
}

#Preview {
    CoordinatorView()
}

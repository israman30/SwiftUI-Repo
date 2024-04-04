//
//  MainPage.swift
//  Coordinator Pattern Navigation
//
//  Created by Israel Manzo on 4/3/24.
//

import SwiftUI

struct MainPage: View {
    @EnvironmentObject var coordinator: Coordinator
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.getPage(Pages.home)
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.getSheet(sheet)
                }
                .navigationDestination(for: Pages.self) { page in
                    coordinator.getPage(page)
                }
                .onOpenURL { url in
                    print("Some url to open")
                }
        }
    }
}

#Preview {
    MainPage()
        .environmentObject(Coordinator())
}

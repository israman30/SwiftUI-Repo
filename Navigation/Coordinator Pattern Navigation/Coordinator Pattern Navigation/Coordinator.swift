//
//  Coordinator.swift
//  Coordinator Pattern Navigation
//
//  Created by Israel Manzo on 4/3/24.
//

import SwiftUI

@MainActor
final class Coordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    @Published var page: Pages = .home
    @Published var sheet: Sheets?
    @Published var currentProduct: String?
    
    let productsList = ["Ferrari", "Prosche", "Jaguar", "Audi"]
    
    func goHome() {
        path.removeLast(path.count)
    }
    
    func showProductsList() {
        path.append(Pages.list)
    }
    
    func gotToProductDetail(product: String) {
        currentProduct = product
        path.append(Pages.detail)
    }
    
    func showSheet() {
        sheet = .sheet
    }
    
    @ViewBuilder
    func getPage(_ page: Pages) -> some View {
        switch page {
        case .home:
            HomeView()
        case .list:
            ProductView()
        case .detail:
            ProductDetailView()
        }
    }
    
    @ViewBuilder
    func getSheet(_ sheet: Sheets) -> some View {
        switch sheet {
        case .sheet:
            SheetView()
        }
    }
}

enum Pages: String, CaseIterable, Identifiable {
    case home, list, detail
    
    var id: String { self.rawValue }
}

enum Sheets: String, CaseIterable, Identifiable {
    case sheet
    
    var id: String { self.rawValue }
}

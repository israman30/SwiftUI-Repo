//
//  Coordinator.swift
//  Coordinator Pattern Navigation
//
//  Created by Israel Manzo on 4/3/24.
//

import SwiftUI

final class Coordinator: ObservableObject {
    
    
    
    func goHome() {
        
    }
    
    func showProductsList() {
        
    }
    
    func gotToProductDetail(product: String) {
        
    }
    
    func showSheet() {
        
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

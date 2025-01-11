//
//  Coordinator.swift
//  Coordinator Tree component
//
//  Created by Israel Manzo on 1/10/25.
//

import Foundation

protocol Steps: Equatable, Hashable { }

enum ItemSteps: Steps {
    case detail
    case addToCart
}

enum WalletSteps: Steps {
    case detail
}

enum SearchSteps: Steps {
    case profile
}

enum PurchaseSteps: Steps {
    case addToCart
    case selectPaymentMethod
    case buyItem
    case summary
}

extension ItemSteps: Identifiable {
    var id: String {
        switch self {
        case .detail: 
            return "detail"
        case .addToCart: 
            return "addToCart"
        }
    }
}

extension PurchaseSteps: Identifiable {
    var id: String {
        switch self {
        case .addToCart: 
            return "addToCart"
        case .selectPaymentMethod: 
            return "selectPaymentMethod"
        case .buyItem: 
            return "buyItem"
        case .summary:
        }
    }
}

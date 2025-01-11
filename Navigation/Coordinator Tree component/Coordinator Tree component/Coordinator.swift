//
//  Coordinator.swift
//  Coordinator Tree component
//
//  Created by Israel Manzo on 1/10/25.
//

import SwiftUI

protocol Steps: Equatable, Hashable { }

enum ItemSteps: Steps {
    case detail
    case addToCart
}

enum WalletSteps: Steps {
    case detail
}

enum SettingsSteps: Steps {
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

protocol Coordinator: ObservableObject {
    associatedtype CoordinatorSteps: Steps
    associatedtype CoordinatorView: View
    
    var path: [CoordinatorSteps] { get set }
    
    func redirect(to path: CoordinatorSteps) -> CoordinatorView
}

final class ItemsCoordinator: ObservableObject {
    @Published var path: [ItemSteps] = []
    
    func goBack() {
        path.removeLast()
    }
    
    func navigateToDetail() {
        path.append(.detail)
    }
    
    @ViewBuilder
    func redirect(to path: ItemSteps) -> some View {
        switch path {
        case .detail:
            // TODO: - add views
            EmptyView()
        case .addToCart:
            EmptyView()
        }
    }
}

final class WalletCoordinator: ObservableObject {
    @Published var path: [WalletSteps] = []
    
    func goBack() {
        path.removeLast()
    }
    
    func navigateToDetail() {
        path.append(.detail)
    }
    
    @ViewBuilder
    func redirect(to path: WalletSteps) -> some View {
        switch path {
        case .detail:
            EmptyView()
        }
    }
}

final class SettingsCoordinator: ObservableObject {
    @Published var path: [SettingsSteps] = []
    
    func goBack() {
        path.removeLast()
    }
    
    func navigateToProfile() {
        path.append(.profile)
    }
    
    @ViewBuilder
    func redirect(to path: SettingsSteps) -> some View {
        switch path {
        case .profile:
            EmptyView()
        }
    }
}

final class PurchaseCoordinator: ObservableObject {
    unowned var parent: ItemsCoordinator
    @Published var path: [PurchaseSteps] = []
    
    init(parent: ItemsCoordinator) {
        self.parent = parent
    }
    
    func navigateToPaymentMethod() {
        path.append(.selectPaymentMethod)
    }
    
    func navigateToSelectBuyItem() {
        path.append(.buyItem)
    }
    
    func navigateToPurchaseSummary() {
        path.append(.summary)
    }
    
    func goBack() {
        path.removeLast()
    }
    
    @ViewBuilder
    func redirect(to path: PurchaseSteps) -> some View {
        switch path {
        case .addToCart:
            EmptyView()
        case .selectPaymentMethod:
            EmptyView()
        case .buyItem:
            EmptyView()
        case .summary:
            EmptyView()
        }
    }
}

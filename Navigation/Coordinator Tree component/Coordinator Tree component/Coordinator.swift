//
//  Coordinator.swift
//  Coordinator Tree component
//
//  Created by Israel Manzo on 1/10/25.
//

import SwiftUI

// MARK: 1. Define Steps:
// The Steps protocol defines the steps for different navigations. These steps are used to uniquely identify the view transitions.
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

// MARK: 2. Add Coordinators
// The Coordinator protocol is the backbone of this pattern. It handles navigation between different views.

protocol Coordinator: ObservableObject {
    associatedtype CoordinatorSteps: Steps
    associatedtype CoordinatorView: View
    
    var path: [CoordinatorSteps] { get set }
    
    func redirect(to path: CoordinatorSteps) -> CoordinatorView
}

// MARK: 3. Coordinators for Each Module:
// Multiple coordinators are defined for managing different flows within the app, like ItemsCoordinator, WalletCoordinator, and SettingsCoordinator. Each coordinator manages its own view stack.

final class ItemsCoordinator: ObservableObject, Coordinator {
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
            let viewModel = DetailViewModel(coordinator: self, detailText: "Item Detail")
            DetailView(viewModel: viewModel)
                .navigationBarBackButtonHidden()
        case .addToCart:
            let coordinator = PurchaseCoordinator(parent: self)
            coordinator.redirect(to: .addToCart)
        }
    }
}

final class WalletCoordinator: ObservableObject, Coordinator {
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
            let viewModel = WalletViewModel(coordinator: self, detailText: "Wallet Detail")
            WalletView(viewModel: viewModel)
                .navigationBarBackButtonHidden()
        }
    }
}

final class SettingsCoordinator: ObservableObject, Coordinator {
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
            let viewModel = SettingsTabViewModel(coordinator: self)
            SettingsTabView(viewModel: viewModel)
                .navigationBarBackButtonHidden()
        }
    }
}

final class PurchaseCoordinator: ObservableObject, Coordinator {
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
            let viewModel = AddToCartViewModel(coordinator: self, detailText: "Add to Cart")
            AddToCartView(viewModel: viewModel)
        case .selectPaymentMethod:
            let viewModel = PaymentMethodViewModel(coordinator: self, detailText: "Select payemnt method")
            PaymentMethodView(viewModel: viewModel)
        case .buyItem:
            let viewModel = BuyItemViewModel(coordinator: self, detailText: "Buy Item")
            BuyItemView(viewModel: viewModel)
        case .summary:
            Text("Purhase Summary")
        }
    }
}

// MARK: 4. Navigation Modifier:
// The NavigationSetupModifier centralizes the use of NavigationStack across the app. It ties a coordinator to a view's navigation stack so that any navigation changes update the UI.
// This is where we centralised our NavigationStack within the app.

struct NavigationSetupModifier<CoordinatorType: Coordinator>: ViewModifier {
    @ObservedObject var coordinator: CoordinatorType
    
    func body(content: Content) -> some View {
        NavigationStack(path: $coordinator.path) {
            content
                .navigationDestination(for: CoordinatorType.CoordinatorSteps.self) { step in
                    coordinator.redirect(to: step)
                }
        }
    }
}

extension View {
    func applyNavigation<CoordinatorType: Coordinator>(coordinator: CoordinatorType) -> some View {
        self.modifier(NavigationSetupModifier(coordinator: coordinator))
    }
}

// MARK: 4. Tab View:
// The app’s main entry point is a TabView that displays different tabs for each module (Items, Wallet, Profile). Each tab is managed by its respective coordinator.

struct HomeView: View {
    @ObservedObject var itemsCoordinator = ItemsCoordinator()
    @ObservedObject var walletCoordinator = WalletCoordinator()
    @ObservedObject var profileCoordinator = SettingsCoordinator()
    
    var body: some View {
        TabView {
            ItemsTabView(viewModel: ItemsTabViewModel(coordinator: itemsCoordinator))
                .tabItem {
                    Label("Tab 1", systemImage: "1.circle")
                }
            WalletTabView(viewModel: WalletTabViewModel(coordinator: walletCoordinator))
                .tabItem {
                    Label("Tab 2", systemImage: "2.circle")
                }
            SettingsTabView(viewModel: SettingsTabViewModel(coordinator: profileCoordinator))
                .tabItem {
                    Label("Tab 3", systemImage: "3.circle")
                }
        }
    }
}

// MARK: 5. Other screen and view models:
final class ItemsTabViewModel: ObservableObject {
    @Published var coordinator: ItemsCoordinator
    
    init(coordinator: ItemsCoordinator) {
        self.coordinator = coordinator
    }
}

struct ItemsTabView: View {
    @ObservedObject var viewModel: ItemsTabViewModel
    
    var body: some View {
        VStack {
            Text("Item Tab")
            Button("Go to item details") {
                viewModel.coordinator.navigateToDetail()
            }
        }
        .applyNavigation(coordinator: viewModel.coordinator)
    }
}

final class WalletTabViewModel: ObservableObject {
    @Published var coordinator: WalletCoordinator
    
    init(coordinator: WalletCoordinator) {
        self.coordinator = coordinator
    }
}

struct WalletTabView: View {
    @ObservedObject var viewModel: WalletTabViewModel
    
    var body: some View {
        VStack {
            Text("Wallet Tab")
            Button("Go to wallet details") {
                viewModel.coordinator.navigateToDetail()
            }
        }
        .applyNavigation(coordinator: viewModel.coordinator)
    }
}

final class SettingsTabViewModel: ObservableObject {
    @Published var coordinator: SettingsCoordinator
    
    init(coordinator: SettingsCoordinator) {
        self.coordinator = coordinator
    }
}

struct SettingsTabView: View {
    @ObservedObject var viewModel: SettingsTabViewModel
    
    var body: some View {
        VStack {
            Text("Settings Tab")
            Button("Go to settings details") {
                viewModel.coordinator.navigateToProfile()
            }
        }
        .applyNavigation(coordinator: viewModel.coordinator)
    }
}

final class AddToCartViewModel: Identifiable {
    let id = UUID()
    let detailText: String
    let coordinator: PurchaseCoordinator
    
    init(coordinator: PurchaseCoordinator, detailText: String) {
        self.detailText = detailText
        self.coordinator = coordinator
    }
}

struct AddToCartView: View {
    @Environment(\.dismiss) var dismiss
    let viewModel: AddToCartViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.detailText)
            Button("Select payment method") {
                viewModel.coordinator.navigateToPaymentMethod()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }
        }
        .applyNavigation(coordinator: viewModel.coordinator)
    }
}

final class PaymentMethodViewModel: Identifiable {
    let id = UUID()
    let detailText: String
    let coordinator: PurchaseCoordinator
    
    init(coordinator: PurchaseCoordinator, detailText: String) {
        self.coordinator = coordinator
        self.detailText = detailText
    }
}

struct PaymentMethodView: View {
    let viewModel: PaymentMethodViewModel
    
    var body: some View {
        Text(viewModel.detailText)
        Button("Buy Item") {
            viewModel.coordinator.navigateToSelectBuyItem()
        }
    }
}

final class BuyItemViewModel: Identifiable {
    let id = UUID()
    let detailText: String
    let coordinator: PurchaseCoordinator
    
    init(coordinator: PurchaseCoordinator, detailText: String) {
        self.coordinator = coordinator
        self.detailText = detailText
    }
}

struct BuyItemView: View {
    let viewModel: BuyItemViewModel
    
    var body: some View {
        Text(viewModel.detailText)
        Button("Go to Summary") {
            viewModel.coordinator.navigateToPurchaseSummary()
        }
    }
}

final class DetailViewModel: Identifiable {
    let id = UUID()
    let detailText: String
    var coordinator: ItemsCoordinator
    
    init(coordinator: ItemsCoordinator, detailText: String) {
        self.coordinator = coordinator
        self.detailText = detailText
    }
}

struct DetailView: View {
    let viewModel: DetailViewModel
    @State private var step: ItemSteps?
    
    var body: some View {
        VStack {
            Text(viewModel.detailText)
            Button("Add to cart") {
                step = .addToCart
            }
        }
        .fullScreenCover(item: $step) { step in
            viewModel.coordinator.redirect(to: step)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("< Back") {
                    viewModel.coordinator.goBack()
                }
            }
        }
    }
}

final class WalletViewModel: Identifiable {
    let id = UUID()
    let detailText: String
    var coordinator: WalletCoordinator
    
    init(coordinator: WalletCoordinator, detailText: String) {
        self.detailText = detailText
        self.coordinator = coordinator
    }
}

struct WalletView: View {
    let viewModel: WalletViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.detailText)
                .font(.largeTitle)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("< Back") {
                    viewModel.coordinator.goBack()
                }
            }
        }
    }
}

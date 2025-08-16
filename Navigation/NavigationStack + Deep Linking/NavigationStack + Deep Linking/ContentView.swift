//
//  ContentView.swift
//  NavigationStack + Deep Linking
//
//  Created by Israel Manzo on 8/15/25.
//

import SwiftUI
import Observation

enum FlightRoute: Hashable, Codable {
    case home
    case flight
    case flightDetail(id: UUID)
    case seatSelected(flightId: UUID)
    case checkout(fligthId: UUID, seat: String)
    case setList(city: String)
}

@Observable
final class NavigationModel {
    var stack: [FlightRoute] = []
    
    func reset() {
        stack.removeAll()
    }
    
    func push(_ route: FlightRoute) {
        stack.append(route)
    }
    
    func pop() {
        guard !stack.isEmpty else { return }
        stack.removeLast()
    }
    
    func replace(_ route: [FlightRoute]) {
        guard !stack.isEmpty else { return }
        stack = route
    }
    
    func replaceLast(_ route: FlightRoute) {
        guard !stack.isEmpty else { return }
        stack[stack.count - 1] = route
    }
}

struct RootView: View {
    @Environment(NavigationModel.self) private var navigation
    
    var body: some View {
        @Bindable var navigation = navigation
        NavigationStack(path: $navigation.stack) {
            ContentView()
                .navigationDestination(for: FlightRoute.self) { route in
                    switch route {
                    case .home:
                        ContentView()
                    case .flight:
                        Text("Flight View")
                    case .flightDetail(let id):
                        Text("Flight Detail \(id)")
                    case .seatSelected(let flightId):
                        Text("Seat selected \(flightId)")
                    case .checkout(let flightID, let seat):
                        Text("Checkout with \(flightID) and \(seat)")
                    case .setList(let city):
                        Text("City \(city)")
                    }
                }
        }
        .environment(navigation)
    }
}

/// `View`
struct ContentView: View {
    
    var body: some View {
       Text("Hello World")
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

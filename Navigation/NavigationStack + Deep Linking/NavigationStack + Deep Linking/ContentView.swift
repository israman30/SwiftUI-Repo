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

struct ContentView: View {
    
    var body: some View {
       Text("Hello World")
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

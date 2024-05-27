//
//  ContentView.swift
//  Wifi Connection
//
//  Created by Israel Manzo on 5/26/24.
//

import SwiftUI
import Network

@Observable
final class NetworkMonitor {
    private let networkMonitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "Wifi")
    var isConnected = false
    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        networkMonitor.start(queue: monitorQueue)
    }
}

struct ContentView: View {
    
    @Environment(NetworkMonitor.self) private var networkMonitor
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Connection status")
                .font(.title)
            
            Image(systemName: networkMonitor.isConnected ? "wifi" : "wifi.slash")
                .font(.title)
                .foregroundStyle(networkMonitor.isConnected ? .blue : .red)
            
            Text(networkMonitor.isConnected ? "Connected" : "No Connected")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(networkMonitor.isConnected ? .blue : .red)
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environment(NetworkMonitor())
}

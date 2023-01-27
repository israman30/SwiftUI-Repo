//
//  HomeView.swift
//  ModuleONE
//
//  Created by Israel Manzo on 1/25/23.
//

import SwiftUI
import UIDesignKit
import NetworkServicesKit

struct HomeView: View {
    
    
    var users = [User]()
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                
        }
        .onAppear {
//            fetchUsers()
        }
        
    }
    
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

class NetworkVM: ObservableObject {
    @Published var users = [User]()
    let network = NetworkServicesKitImplementation()
    func fetchUsers() {
        Task {
            do {
                let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
                users = try await network.get(url: url)
            } catch {
                
            }
        }
    }
}

struct User: Decodable {
    let name: String
    let username: String
    let email: String
}

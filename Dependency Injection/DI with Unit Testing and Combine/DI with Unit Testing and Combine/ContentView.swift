//
//  ContentView.swift
//  DI with Unit Testing and Combine
//
//  Created by Israel Manzo on 6/25/23.
//

import SwiftUI
import Combine

struct User: Decodable {
    let id: Int
    let name: String
    let email: String
}

protocol NetworkServicesProtocol {
    func getUsers() -> AnyPublisher<[User], Error>
}

class NetworkServices: NetworkServicesProtocol {
    
    let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
    
    func getUsers() -> AnyPublisher<[User], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [User].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

class MockNetworkServices: NetworkServicesProtocol {
    
    let mockUsers = [
        User(id: 0, name: "John Doe", email: "jdoe@mail.com"),
        User(id: 1, name: "Peter Parker", email: "peter@mail.com"),
        User(id: 2, name: "Tony Stark", email: "ironman@mail.com"),
        User(id: 3, name: "Steve Rogers", email: "americancap@mail.com")
    ]
    
    func getUsers() -> AnyPublisher<[User], Error> {
        Just(mockUsers)
            .tryMap { $0 } // something might fail
            .eraseToAnyPublisher()
    }
}

class ViewModel: ObservableObject {
    
    @Published var users = [User]()
    var cancellable = Set<AnyCancellable>()
    let network: NetworkServicesProtocol
    
    init(_ network: NetworkServicesProtocol) {
        self.network = network
        load()
    }
    
    private func load() {
        network.getUsers()
            .sink { _ in
                
            } receiveValue: { users in
                self.users = users
            }
            .store(in: &cancellable)
    }
}

struct ContentView: View {
    
    @StateObject private var vm: ViewModel
    
    init() {
        self._vm = StateObject(wrappedValue: ViewModel(NetworkServices()))
    }
    
    var body: some View {
        VStack {
            List(vm.users, id: \.id) { user in
                Text(user.name)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

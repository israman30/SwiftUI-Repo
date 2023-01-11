//
//  ContentView.swift
//  Networking
//
//  Created by Israel Manzo on 1/6/23.
//

import SwiftUI

//https://jsonplaceholder.typicode.com/users

struct ContentView: View {
    
    @EnvironmentObject var network: NetworkServices
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(network.users) { user in
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .padding(5)
                    }
                }
            }
        }
        .onAppear {
            network.fetchUser()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NetworkServices())
    }
}

struct User: Decodable, Identifiable {
    var id: Int
    var name: String
    var username: String
    var email: String
    var address: Address
    var phone: String
    var website: String
    var company: Company
    struct Address: Decodable {
        var street: String
        var suite: String
        var city: String
        var zipcode: String
        var geo: Geo
        
        struct Geo: Decodable {
            var lat: String
            var lng: String
        }
    }
    
    struct Company: Decodable {
        var name: String
        var catchPhrase: String
        var bs: String
    }
}

class NetworkServices: ObservableObject {
    
    @Published var users = [User]()
    
    func fetchUser() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                return
            }
            
            do {
                guard let data = data else { return }
                let jsonObject = try JSONDecoder().decode([User].self, from: data)
                DispatchQueue.main.async {
                    self.users = jsonObject
                }
            } catch {
                print("Some error parsing json: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

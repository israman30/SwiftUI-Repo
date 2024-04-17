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
            List {
                ForEach(network.users) { user in
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.title2)
                        VStack(alignment: .leading) {
                            Text(user.username)
                            Text(user.website)
                        }
                        .foregroundColor(.gray)
                        
                    }
                    .padding(5)
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



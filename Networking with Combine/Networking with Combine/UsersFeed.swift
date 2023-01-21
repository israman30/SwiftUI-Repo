//
//  UsersFeed.swift
//  Networking with Combine
//
//  Created by Israel Manzo on 1/20/23.
//

import SwiftUI

struct UsersFeed: View {
    
    @StateObject private var vm: NetworkServicesImplementation

    init() {
        self._vm = StateObject(wrappedValue: NetworkServicesImplementation())
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.users) { user in
                    Text("\(user.name)")
                        .padding(5)
                        .font(.title3)
                }
                .navigationTitle("Network Combine")
            }
            .onAppear {
                vm.load()
            }
        }
    }
}

struct UsersFeed_Previews: PreviewProvider {
    static var previews: some View {
        UsersFeed()
    }
}

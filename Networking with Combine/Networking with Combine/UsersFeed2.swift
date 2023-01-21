//
//  UsersFeed2.swift
//  Networking with Combine
//
//  Created by Israel Manzo on 1/20/23.
//

import SwiftUI

struct UsersFeed2: View {
    
    @StateObject private var vm: NetworkViewModel
    
    init() {
        self._vm = StateObject(wrappedValue: NetworkViewModel())
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
                vm.getUsers()
            }
        }

    }
}

struct UsersFeed2_Previews: PreviewProvider {
    static var previews: some View {
        UsersFeed2()
    }
}

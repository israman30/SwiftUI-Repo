//
//  UserList.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI

struct UserList: View {
    @StateObject var vm = UserViewModel(service: UserService())
    var body: some View {
        List(vm.users) { user in
            Text(user.name)
        }
        .task {
            await vm.loadUsers()
        }
    }
    
    func addUser() {
        
    }
}

#Preview {
    UserList()
}

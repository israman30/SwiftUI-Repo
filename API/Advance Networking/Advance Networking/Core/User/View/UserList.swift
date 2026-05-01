//
//  UserList.swift
//  Advance Networking
//
//  Created by Israel Manzo on 4/30/26.
//

import SwiftUI

// https://jsonplaceholder.typicode.com/users

/**
 "id": 1,
 "name": "Leanne Graham",
 "username": "Bret",
 "email": "Sincere@april.biz",
 */

struct UserList: View {
    @StateObject var vm = UserViewModel()
    var body: some View {
        List(vm.users) { user in
            Text(user.name)
        }
        .task {
            do {
                try await vm.fetchUser()
            } catch {
                
            }
        }
    }
    
    func addUser() {
        
    }
}

#Preview {
    UserList()
}

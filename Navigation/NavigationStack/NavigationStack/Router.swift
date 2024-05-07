//
//  Router.swift
//  NavigationStack
//
//  Created by Israel Manzo on 5/6/24.
//

import SwiftUI

class Router: ObservableObject {
    
    @Published var path = NavigationPath()
    
    func reset() {
        path = NavigationPath()
    }
}

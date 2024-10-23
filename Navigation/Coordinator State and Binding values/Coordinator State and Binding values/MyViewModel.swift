//
//  MyViewModel.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import Foundation

final class MyViewModel: ObservableObject {
    @Published var text: String = "This is data from the View Model"
    @Published var isLoading: Bool = false
    @Published var isUserLoggedIn: Bool = true
    @Published var userActivity: Bool = true
}

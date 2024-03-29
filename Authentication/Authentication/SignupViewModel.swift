//
//  SignupViewModel.swift
//  Authentication
//
//  Created by Israel Manzo on 3/28/24.
//

import SwiftUI
import Combine

protocol SignupNavProtocol: AnyObject {
    func login()
    func signup()
}

extension SignupView {
    
    class ViewModel: ObservableObject {
        
        @Published var email = ""
        @Published var password = ""
        @Published var confirmedPassword = ""
        
        weak var navProtocol: SignupNavProtocol?
        
        func signup() {
            navProtocol?.signup()
        }
        
        func login() {
            navProtocol?.login()
        }
    }
}


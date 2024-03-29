//
//  LoginViewModel.swift
//  Authentication
//
//  Created by Israel Manzo on 3/28/24.
//

import SwiftUI
import Combine

protocol LoginNavProtocol: AnyObject {
    func onSignupTapped()
    func onLoginSuccess()
}

extension LoginView {
    
    class ViewModel: ObservableObject {
        @Published var email = ""
        @Published var password = ""
        
        weak var navDelegate: LoginNavProtocol?
        
        func loginTapped() {
            navDelegate?.onLoginSuccess()
        }
        
        func signupTapped() {
            navDelegate?.onSignupTapped()
        }
        
    }
    
    
}

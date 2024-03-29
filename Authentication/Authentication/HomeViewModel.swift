//
//  HomeViewModel.swift
//  Authentication
//
//  Created by Israel Manzo on 3/28/24.
//

import SwiftUI
import Combine

protocol HomeNavProtocol: AnyObject {
    func logOut()
}

extension HomeView {
    
    class ViewModel: ObservableObject {
        let defaultMessage = "Tap to fecth something"
        
        @Published var infoText = ""
        
        weak var navProtocol: HomeNavProtocol?
        
        func resetInfoText() {
            infoText = defaultMessage
        }
        
        func fetchSecureDate() {
            infoText = "Seom secure data"
        }
        
        func logout() {
            navProtocol?.logOut()
        }
    }
}

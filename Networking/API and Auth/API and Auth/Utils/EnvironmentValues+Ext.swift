//
//  EnvironmentValues+Ext.swift
//  API and Auth
//
//  Created by Israel Manzo on 9/6/25.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var authController = AuthController(networkClient: NetworkClient())
}

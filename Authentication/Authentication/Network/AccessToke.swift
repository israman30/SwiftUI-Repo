//
//  AccessToke.swift
//  Authentication
//
//  Created by Israel Manzo on 3/29/24.
//

import Foundation

struct AccessToken: Codable {
    var accessToken: String
    var refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access"
        case refreshToken = "refresh"
    }
}

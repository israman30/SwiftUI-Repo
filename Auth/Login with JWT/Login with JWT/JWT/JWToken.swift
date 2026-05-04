//
//  JWToken.swift
//  Login with JWT
//
//  Created by Israel Manzo on 5/3/26.
//

import Foundation

struct JWTPayload: Codable {
    let sub: String?
    let email: String?
    let iat: TimeInterval?
    let exp: TimeInterval?
    let iss: String?
    let roles: [String]?
    
    var userId: String? {
        sub
    }
    
    var expirationDate: Date? {
        guard let exp else { return  nil }
        return Date(timeIntervalSince1970: exp)
    }
}

struct JWToken: Codable {
    let accessToken: String
    let refreshToken: String?
    let expiresIn: TimeInterval
    let tokenType: String
    let issuedAt: Date
    
    var expirationDate: Date {
        issuedAt.addingTimeInterval(expiresIn)
    }
    
    var isExpired: Bool {
        Date() >= expirationDate
    }
    
    var isNearExpired: Bool {
        Date() >= expirationDate.addingTimeInterval(-300)
    }
    
    var bearerToken: String {
        "\(tokenType) \(accessToken)"
    }
    
    var payload: JWTPayload? {
        decodePayload()
    }
    
    private func decodePayload() -> JWTPayload? {
        let parts = accessToken.split(separator: ".")
        guard parts.count == 3 else { return nil }
        
         var base64 = String(parts[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let reminder = base64.count % 4
        if reminder > 0 {
            base64 += String(repeating: "=", count: 4 - reminder)
        }
        
        guard let data = Data(base64Encoded: base64) else { return  nil }
        return try? JSONDecoder().decode(JWTPayload.self, from: data)
    }
}

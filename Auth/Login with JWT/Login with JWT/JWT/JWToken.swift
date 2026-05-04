//
//  JWToken.swift
//  Login with JWT
//
//  Created by Israel Manzo on 5/3/26.
//

import Foundation

/// The decoded (unencrypted) JWT claims we care about in the UI.
///
/// Notes:
/// - This payload is **not** trusted for authorization decisions by itself.
/// - We decode it only to show user-facing metadata (email, roles, expiration).
/// - Signature validation must be done server-side (or via a proper JWT verifier).
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

/// A token bundle returned by the auth server.
///
/// We persist the whole token object in the Keychain (not `UserDefaults`) because
/// access/refresh tokens are secrets.
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
    
    /// Decodes the middle JWT segment (payload) using Base64URL rules.
    ///
    /// This intentionally does **not** validate the signature. It is meant for display
    /// and convenience checks (e.g., show email, estimate expiry) only.
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

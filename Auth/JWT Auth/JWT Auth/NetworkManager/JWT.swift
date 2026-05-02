//
//  JWT.swift
//  JWT Auth
//
//  Created by Israel Manzo on 5/2/26.
//

import Foundation

struct JWTClaims: Codable, Equatable {
    var sub: String
    var name: String
    var iat: Int
    var exp: Int
    var iss: String?
    var aud: String?
    
    var isExpired: Bool {
        Date().timeIntervalSince1970 >= TimeInterval(exp)
    }
}

enum JWT {
    static func makeMockToken(
        userId: String,
        name: String,
        issuer: String = "com.israelmanzo.jwt-auth.mock",
        audience: String = "jwt-auth-demo",
        expiresIn seconds: TimeInterval = 60 * 60
    ) throws -> String {
        // Header/payload are real base64url-encoded JSON, so the app can decode claims locally.
        // The "signature" is random bytes — it is not cryptographically meaningful.
        let header = ["alg": "HS256", "typ": "JWT"]
        let now = Int(Date().timeIntervalSince1970)
        let payload = JWTClaims(
            sub: userId,
            name: name,
            iat: now,
            exp: now + Int(seconds),
            iss: issuer,
            aud: audience
        )
        
        let headerData = try JSONSerialization.data(withJSONObject: header, options: [])
        let payloadData = try JSONEncoder().encode(payload)
        
        let headerPart = headerData.base64URLEncodedString()
        let payloadPart = payloadData.base64URLEncodedString()
        
        // Mock signature: looks like a signature but isn't derived from a key.
        let signaturePart = Data(UUID().uuidString.utf8).base64URLEncodedString()
        
        return "\(headerPart).\(payloadPart).\(signaturePart)"
    }
    
    static func decodeClaims(from token: String) throws -> JWTClaims {
        let parts = token.split(separator: ".")
        guard parts.count == 3 else { throw APIError.invalidToken }
        let payloadPart = String(parts[1])
        guard let payloadData = Data(base64URLEncoded: payloadPart) else {
            throw APIError.invalidToken
        }
        return try JSONDecoder().decode(JWTClaims.self, from: payloadData)
    }
}

extension Data {
    func base64URLEncodedString() -> String {
        let base64 = self.base64EncodedString()
        return base64
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
    
    init?(base64URLEncoded string: String) {
        var base64 = string
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let remainder = base64.count % 4
        if remainder > 0 {
            base64.append(String(repeating: "=", count: 4 - remainder))
        }
        
        self.init(base64Encoded: base64)
    }
}

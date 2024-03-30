//
//  AccessTokenStorage.swift
//  Authentication
//
//  Created by Israel Manzo on 3/29/24.
//

import Foundation
import Security

struct AccessTokenStorage {
    private let accessKey = "com.some.auth_class_token"
    
    @discardableResult
    func save(_ token: AccessToken) -> Bool {
        
        _ = get()
        
        guard let data = try? JSONEncoder().encode(token) else {
            return false
        }
        
        let query: [CFString:Any] = [
            kSecClass:kSecClassGenericPassword,
            kSecAttrAccount: accessKey,
            kSecValueData:data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { return false }
        return true
    }
    
    func get() -> AccessToken? {
        let query: [CFString:Any] = [
            kSecClass:kSecClassGenericPassword,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard let data = item as? Data else { return nil }
        
        return try? JSONDecoder().decode(AccessToken.self, from: data)
    }
    
    @discardableResult
    func delete() -> Bool {
        let deleteQuery: [CFString:Any] = [
            kSecClass:kSecClassGenericPassword,
            kSecAttrAccount: accessKey
        ]
        let status = SecItemDelete(deleteQuery as CFDictionary)
        return status == errSecSuccess
    }
}

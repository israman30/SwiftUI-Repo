//
//  Keychain.swift
//  API and Auth
//
//  Created by Israel Manzo on 9/6/25.
//

import Foundation
import Security

struct Keychain<T: Codable> {
    static func set(_ value: T, forKey: String) {
        do {
            let data = try JSONEncoder().encode(value)
            let query: [CFString:Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: forKey,
                kSecValueData: data
            ]
            SecItemDelete(query as CFDictionary) // delete existing data
            
            let status = SecItemAdd(query as CFDictionary, nil)
            
            if status != errSecSuccess {
                print("Error loading item keychain: \(data)")
            }
        } catch {
            print("Error encoding data: \(error)")
        }
    }
    
    static func get(_ key: String) -> T? {
        let query: [CFString:Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess, let data = item as? Data {
            do {
                let value = try JSONDecoder().decode(T.self, from: data)
                return value
            } catch {
                print("Error decoding data: \(error)")
            }
        }
        return nil
    }
    
    static func delete(_ key: String) -> Bool {
        let query: [CFString:Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}

//
//  KeychainManager.swift
//  Login with JWT
//
//  Created by Israel Manzo on 5/3/26.
//

import Foundation
import Security

enum KeychainError: LocalizedError {
    case saveFailed(OSStatus)
    case readFailed(OSStatus)
    case deleteFailed(OSStatus)
    case encodingFailed
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .saveFailed(let oSStatus):
            return "Keychain save failed: \(oSStatus)"
        case .readFailed(let oSStatus):
            return "Keychain read failed: \(oSStatus)"
        case .deleteFailed(let oSStatus):
            return "Keychain delete failed: \(oSStatus)"
        case .encodingFailed:
            return "Token encoding failed"
        case .notFound:
            return "Token not found in Keychain"
        }
    }
}

final class KeychainManager {
    static let shared = KeychainManager()
    private init() { }
    
    private let service = Bundle.main.bundleIdentifier ?? "com.app.default"
    
    func save<T: Encodable>(_ value: T, forKey key: String) throws {
        guard let data = try? JSONEncoder().encode(value) else {
            throw KeychainError.encodingFailed
        }
        
        try? delete(forKey: key)
        
        let query: [CFString:Any] = [
            kSecClass:           kSecClassGenericPassword,
            kSecAttrService:     service,
            kSecAttrAccount:     key,
            kSecValueData:       data,
            kSecAttrAccessible:  kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status)
        }
    }
    
    func read<T: Decodable>(_ type: T.Type, forKey key: String) throws -> T {
        let query: [CFString: Any] = [
            kSecClass:            kSecClassGenericPassword,
            kSecAttrService:      service,
            kSecAttrAccount:      key,
            kSecReturnData:       true,
            kSecMatchLimit:       kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw KeychainError.notFound
            }
            throw KeychainError.readFailed(status)
        }
        
        guard let data = result as? Data,
              let value = try? JSONDecoder().decode(type, from: data) else {
            throw KeychainError.encodingFailed
        }
        return value
    }
    
    func delete(forKey key: String) throws {
        let query: [CFString: Any] = [
            kSecClass:        kSecClassGenericPassword,
            kSecAttrService:  service,
            kSecAttrAccount:  key
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(status)
        }
    }
    
    func exists(forKey key: String) -> Bool {
        (try? read(Data.self, forKey: key)) != nil
    }
}

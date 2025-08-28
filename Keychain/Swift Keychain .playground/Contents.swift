import UIKit
import Security

/**
 `Keychain services handles data encryption and storage (including data attributes) in a keychain, which is an encrypted database stored on disk. Later, authorized apps use keychain services to find the item and decrypt its data.
 
 If you have created the cryptographic key with `SecKeyCreateRandomKey(_:_:)` and specify the `kSecAttrIsPermanent` in the attributes dictionary to true, it will be stored in the default keychain automatically while creating!
 */
final class KeychainService {
    enum KeychainError: Error {
        case saveError(OSStatus)
        case retrieveError(OSStatus)
        case failToExtractInfo
        case deleteError(OSStatus)
    }
    
    private let services = "com.some.service.name"
    
    func saveGenericPassword(password: String = "@12345", account: String = "someaccount") async throws {
        let passwordData = Data(password.utf8)
        
        // For a full list of attribute keys supported for a generic password item:
        // https://developer.apple.com/documentation/security/ksecclassgenericpassword
        var query = makePrimaryDictionary(for: account)
        query[kSecValueData as String] = passwordData
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            throw KeychainError.saveError(status)
        }
    }
    
    private func makePrimaryDictionary(for account: String) -> [String: Any] {
        return [
            // the class of the key
            kSecClass as String: kSecClassGenericPassword,
            // attributes form the composite primary keys of a generic password item
            kSecAttrAccount as String: account,
            kSecAttrService as String: services
        ]
    }
    
    
    func retrieveGenericPAssword(for account: String = "someaccount") async throws -> String {
        var query = makePrimaryDictionary(for: account)
        query[kSecReturnData as String] = true
        query[kSecReturnAttributes as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        // initiate the search
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        print("status: \(status.string)")
        
        guard status == errSecSuccess else {
            throw KeychainError.retrieveError(status)
        }
        
        guard let resultItem = item as? [String: Any] else {
            throw KeychainError.failToExtractInfo
        }
        
        guard let existingItem = item as? [String:Any],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: String.Encoding.utf8),
              let retrievedAccount = existingItem[kSecAttrAccount as String] as? String, // same as the account we pass in
              retrievedAccount == account else {
            throw KeychainError.failToExtractInfo
        }
        return password
    }
}

extension OSStatus {
    var string: String {
        let string = SecCopyErrorMessageString(self, nil)
        return string as? String ?? "code: \(self)"
    }
}


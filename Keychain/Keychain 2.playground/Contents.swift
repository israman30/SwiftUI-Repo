import UIKit
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
}

//
//  KeychainManager.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-11-30.
//

import Foundation

@globalActor
actor KeychainActor {
    static let shared  = KeychainActor()
}

@KeychainActor
final class KeychainManager {
    static let shared = KeychainManager()
    
    private init() {}
    
    func save<T: Codable>(_ item: T, forKey key: String) {
        guard let data = try? JSONEncoder().encode(item) else {
            return
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func retrieve<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess, let data = item as? Data {
            let decodedItem = try? JSONDecoder().decode(T.self, from: data)
            return decodedItem
        } else {
            return nil
        }
    }
    
    func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}

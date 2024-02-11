//
//  KeychainManager.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-10.
//

import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()

    private init() {}

    func save(data: Data, identifier: String) -> HTTPStatusCode {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: identifier,
            kSecValueData as String: data] as [String: Any]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        
        return status != errSecSuccess ? .localError : .success
    }
    
    func save(dictionary: Dictionary<String, Any>, identifier: String) -> HTTPStatusCode {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else { return .localError }
        return self.save(data: data, identifier: identifier)
    }

    func retrieve(identifier: String) -> [String: Any]? {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: identifier,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne] as [String: Any]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == noErr,
              let data = item as? Data,
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> else { return nil }
        return dictionary
        
    }
    
    func delete(identifier: String) -> HTTPStatusCode {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: identifier] as [String: Any]

        let status = SecItemDelete(query as CFDictionary)
        return status != errSecSuccess && status != errSecItemNotFound ? .localError : .success
    }
}

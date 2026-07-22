//
//  KeychainDB.swift
//  app.totp
//
//  Created by PropertyShare on 18/06/25.
//

import Foundation
import Security

//// Keychain helper class
//class KeychainDB {
//    
//    // Create (Add/Save Data)
//    static func addKeychainItem(service: String, account: String, data: Data) -> Bool {
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrService as String: service,
//            kSecAttrAccount as String: account,
//            kSecValueData as String: data
//        ]
//        
//        let status = SecItemAdd(query as CFDictionary, nil)
//        return status == errSecSuccess
//    }
//    
//    // Read (Retrieve Data)
//    static func getKeychainItem(service: String, account: String) -> Data? {
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrService as String: service,
//            kSecAttrAccount as String: account,
//            kSecReturnData as String: kCFBooleanTrue!,
//            kSecMatchLimit as String: kSecMatchLimitOne
//        ]
//        
//        var dataTypeRef: CFTypeRef?
//        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
//        
//        guard status == errSecSuccess else { return nil }
//        return dataTypeRef as? Data
//    }
//    
//    // Update
//    static func updateKeychainItem(service: String, account: String, newData: Data) -> Bool {
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrService as String: service,
//            kSecAttrAccount as String: account
//        ]
//        
//        let attributesToUpdate: [String: Any] = [
//            kSecValueData as String: newData
//        ]
//        
//        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
//        return status == errSecSuccess
//    }
//    
//    // Delete
//    static func deleteKeychainItem(service: String, account: String) -> Bool {
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrService as String: service,
//            kSecAttrAccount as String: account
//        ]
//        
//        let status = SecItemDelete(query as CFDictionary)
//        return status == errSecSuccess
//    }
//}


import Foundation
import Security

final class KeychainDB {
    
    static let shared = KeychainDB()
    private init() {}

    private let service = "com.yourapp.keychain.list"

    func saveList<T: Codable>(_ list: [T], forKey key: String) {
        if let data = try? JSONEncoder().encode(list) {
            save(data: data, forKey: key)
        }
    }

    func getList<T: Codable>(forKey key: String) -> [T] {
        guard let data = read(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([T].self, from: data)) ?? []
    }

    func addItem<T: Codable & Equatable>(_ item: T, forKey key: String) {
        var currentList: [T] = getList(forKey: key)
        currentList.append(item)
        saveList(currentList, forKey: key)
    }

    func deleteItem<T: Codable & Equatable>(_ item: T, forKey key: String) {
        var currentList: [T] = getList(forKey: key)
        currentList.removeAll { $0 == item }
        saveList(currentList, forKey: key)
    }

    // MARK: - Core Keychain Access

    private func save(data: Data, forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary) // Delete existing item

        var attributes = query
        attributes[kSecValueData as String] = data

        SecItemAdd(attributes as CFDictionary, nil)
    }

    private func read(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        return status == errSecSuccess ? (result as? Data) : nil
    }
}

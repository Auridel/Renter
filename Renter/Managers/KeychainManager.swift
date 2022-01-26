//
//  KeychainManager.swift
//  Renter
//
//  Created by Oleg Efimov on 26.01.2022.
//

import Foundation

final class KeychainManager {
    
    private let service = "com.oleg.efimov.renter.app.Renter"
    
    enum KeychainError: Error, Equatable {
        case itemNotFound, duplicateItem, invalidItemFormat, unexpectedStatus(OSStatus)
    }
    
    public func savePassword(password: Data, account: String) throws {
        
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrSynchronizable as String: kCFBooleanTrue,
            kSecValueData as String: password as AnyObject
        ]
        
        let status = SecItemAdd(query as CFDictionary,
                                nil)
        
        if status == errSecDuplicateItem {
            throw KeychainError.duplicateItem
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    public func updatePassword(password: Data, account: String) throws {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecAttrSynchronizable as String: kCFBooleanTrue,
            kSecClass as String: kSecClassGenericPassword
        ]
        let attributes: [String: AnyObject] = [
            kSecValueData as String: password as AnyObject
        ]
        
        let status = SecItemUpdate(query as CFDictionary,
                                   attributes as CFDictionary)
        
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    public func readPassword(account: String) throws -> Data {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecAttrSynchronizable as String: kCFBooleanTrue,
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue
        ]
        
        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary,
                                         &itemCopy)
        
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
        
        guard let password = itemCopy as? Data else {
            throw KeychainError.invalidItemFormat
        }
        
        return password
    }
    
    public func deletePassword(account: String) throws {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecAttrSynchronizable as String: kCFBooleanTrue,
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
}

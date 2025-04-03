// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public final class KeyChainModule {
    public enum Key: String {
        case accessToken
        case refreshToken
        case isLogin
    }
    
    public static func create(key: Key, data: String) throws {
        guard let valueData = data.data(using: .utf8) else {
            throw KeyChainError.dataEncodingFailed
        }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecValueData: valueData
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        switch status {
        case errSecSuccess:
            print("keychain success")
        case errSecDuplicateItem:
            try update(key: key, data: data)
        default:
            print("keychain create failure")
            throw KeyChainError.keyChainOperationFailed(status)
        }
    }
    
    public static func read(key: Key) throws -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess else {
            throw KeyChainError.keyChainOperationFailed(status)
        }
        
        guard let retrieveData = dataTypeRef as? Data,
              let value = String(data: retrieveData, encoding: String.Encoding.utf8) else {
            throw KeyChainError.dataEncodingFailed
        }
        
        return value
    }
    
    public static func update(key: Key, data: String) throws {
        guard let valueData = data.data(using: .utf8) else {
            throw KeyChainError.dataEncodingFailed
        }
        
        let previousQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
        ]
        
        let updateQuery: [CFString: Any] = [
            kSecValueData: valueData
        ]
        
        let status = SecItemUpdate(previousQuery as CFDictionary, updateQuery as CFDictionary)
        
        guard status == errSecSuccess else {
            throw KeyChainError.keyChainOperationFailed(status)
        }
        
        print("keychain update success")
    }
    
    public static func delete(key: Key) throws {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        // 키가 없으면 errSecItemNotFound가 반환 -> 성공으로 처리
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeyChainError.keyChainOperationFailed(status)
        }
    }
}

// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public final class KeyChainModule {
    public enum Key: String {
        case accessToken
        case refreshToken
        case isLogin
    }
    
    public static func create(key: Key, data: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecValueData: data.data(using: .utf8) as Any
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        switch status {
        case errSecSuccess:
            print("keychain success")
        case errSecDuplicateItem:
            update(key: key, data: data)
        default:
            print("keychain create failure")
        }
    }
    
    public static func read(key: Key) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            guard let retrieveData = dataTypeRef as? Data else {
                return nil
            }
            let value = String(data: retrieveData, encoding: String.Encoding.utf8)
            return value
        } else {
            return nil
        }
    }
    
    public static func update(key: Key, data: String) {
        let previousQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
        ]
        
        let updateQuery: [CFString: Any] = [
            kSecValueData: data.data(using: .utf8) as Any
        ]
        
        let status = SecItemUpdate(previousQuery as CFDictionary, updateQuery as CFDictionary)
        
        switch status {
        case errSecSuccess:
            print("keychain update success")
        default:
            print("keychain update failure")
        }
    }
    
    public static func delete(key: Key) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        assert(status == noErr, "키체인 삭제 실패")
    }
}

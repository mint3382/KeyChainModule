// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public final class KeyChainModule {
    public enum Key: String {
        case accessToken
        case refreshToken
    }
    
    public class func create(key: Key, data: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecValueData: data.data(using: .utf8) as Any
        ]
        
        let status = SecItemAdd(query, nil)
        
        switch status {
        case errSecSuccess:
            print("keychain success")
        case errSecDuplicateItem:
            update(key: key, data: data)
        default:
            print("keychain create failure")
        }
    }
    
    public class func read(key: Key) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
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
    
    public class func update(key: Key, data: String) {
        let previousQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
        ]
        
        let updateQuery: NSDictionary = [
            kSecValueData: data.data(using: .utf8) as Any
        ]
        
        let status = SecItemUpdate(previousQuery, updateQuery)
        
        switch status {
        case errSecSuccess:
            print("keychain update success")
        default:
            print("keychain update failure")
        }
    }
    
    public class func delete(key: Key) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ]
        
        let status = SecItemDelete(query)
        assert(status == noErr, "키체인 삭제 실패")
    }
}

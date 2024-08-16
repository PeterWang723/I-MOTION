//
//  JWTKeyChain.swift
//  imotion
//
//  Created by Peter Wang on 2024/7/1.
//

import Foundation
import Security

class JWTKeyChain {
    static let shared = JWTKeyChain()
    

    func save(jwt: String, privacyL:String, houseHold:String?, forKey key: String) {
        
        let dict: [String: String?] = [
            "jwt": jwt,
            "privacyLevel": privacyL,
            "houseHold": houseHold
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: [])
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: jsonData
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Error saving JWT: \(status)")
        }
    }
    
    func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            print("Successfully deleted item for key: \(key)")
        } else {
            print("Error deleting item for key: \(key), status: \(status)")
        }
    }

    func retrieveJWT(forKey key: String) -> [String:String?]? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecSuccess {
            if let retrievedData = item as? Data {
                let retrievedDict = try! JSONSerialization.jsonObject(with: retrievedData, options: []) as! [String: String?]
                return retrievedDict
            }
        } else {
            print("Error retrieving data from the keychain: \(status)")
        }
        return nil
    }
}

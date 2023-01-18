//
//  OAuth2TokenStorage.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 08.01.2023.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    
    private let keychainWrapper = KeychainWrapper.standard

    private enum Keys: String {
        case bearerToken
    }

    var bearerToken: String? {
        get {
            keychainWrapper.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            if let newValue {
                keychainWrapper.set(newValue, forKey: Keys.bearerToken.rawValue)
            } else {
                keychainWrapper.removeObject(forKey: Keys.bearerToken.rawValue)
            }
        }
    }
}

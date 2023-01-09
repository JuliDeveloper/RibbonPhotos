//
//  OAuth2TokenStorage.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 08.01.2023.
//

import Foundation

class OAuth2TokenStorage {
    
    private let userDefaults = UserDefaults.standard

    private enum Keys: String {
        case bearerToken
    }

    var bearerToken: String? {
        get {
            userDefaults.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            if let newToken = newValue {
                userDefaults.set(newToken, forKey: Keys.bearerToken.rawValue)
            } else {
                userDefaults.removeObject(forKey: Keys.bearerToken.rawValue)
            }
        }
    }
}

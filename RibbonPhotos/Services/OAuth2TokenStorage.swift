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
            guard let data = newValue else { return }
            userDefaults.set(data, forKey: Keys.bearerToken.rawValue)
        }
    }
}

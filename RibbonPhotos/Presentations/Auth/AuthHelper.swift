//
//  AuthHelper.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 04.02.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}

class AuthHelper: AuthHelperProtocol {
    let authConfiguration: AuthConfiguration
    
    init(authConfiguration: AuthConfiguration = .standart) {
        self.authConfiguration = authConfiguration
    }
    
    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
    }
    
    func authURL() -> URL {
        guard var urlComponents = URLComponents(string: authConfiguration.unsplashAuthorizeURLString) else { return URL(fileURLWithPath: "") }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: authConfiguration.accessKey),
            URLQueryItem(name: "redirect_uri", value: authConfiguration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: authConfiguration.accessScope)
        ]
        
        guard let url = urlComponents.url else { return URL(fileURLWithPath: "") }
        return url
    }
    
    func code(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

//
//  OAuth2Service.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 08.01.2023.
//

import Foundation

protocol OAuth2ServiceProtocol {
    func fetchAuthToken(_ code: String, _ completion: @escaping (Result<String, Error>) -> Void)
}

private enum NetworkError: Error {
    case codeError
}

final class OAuth2Service: OAuth2ServiceProtocol {
    
    let oauth2TokenStorage = OAuth2TokenStorage()
    
    func fetchAuthToken(_ code: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        var urlComponents = URLComponents(string: Constants.unsplashAuthorizeTokenURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        let url = urlComponents.url!
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                if response.statusCode <= 200 && response.statusCode < 300 {
                    print("STATUSCODE: \(response.statusCode)")
                    completion(.success("\(response.statusCode)"))
                } else {
                    completion(.failure(NetworkError.codeError))
                }
            } else if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    print("TOKEN: \(result.accessToken)")
                    self.oauth2TokenStorage.bearerToken = result.accessToken
                    completion(.success(result.accessToken))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
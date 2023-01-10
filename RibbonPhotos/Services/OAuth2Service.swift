//
//  OAuth2Service.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 08.01.2023.
//

import Foundation

protocol OAuth2ServiceProtocol {
    func fetchData(_ code: String, _ completion: @escaping (Result<Data, Error>) -> Void)
    func fetchAuthToken(_ code: String, _ completion: @escaping (Result<String, Error>) -> Void)
}

private enum NetworkError: Error {
    case codeError
}

final class OAuth2Service: OAuth2ServiceProtocol {
    func fetchData(_ code: String, _ completion: @escaping (Result<Data, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeTokenURLString) else { return }
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
            if let data = data,
               let response = response as? HTTPURLResponse {
                if response.statusCode <= 200 && response.statusCode < 300 {
                    completion(.success(data))
                } else if let error = error  {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func fetchAuthToken(_ code: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        fetchData(code) { result in
            switch result {
            case .success(let data):
                do {
                    let responseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    print("TOKEN: \(responseBody.accessToken)")
                    completion(.success(responseBody.accessToken))
                } catch {
                    completion(.failure(NetworkError.codeError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

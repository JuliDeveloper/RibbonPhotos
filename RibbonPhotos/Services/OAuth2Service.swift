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
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private func makeRequest(code: String) -> URLRequest {
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeTokenURLString) else { return URLRequest(url: URL(fileURLWithPath: "")) }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let url = urlComponents.url else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    private func fetchData(_ code: String, _ completion: @escaping (Result<Data, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        let request = makeRequest(code: code)
        let session = urlSession
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response as? HTTPURLResponse {
                if response.statusCode >= 200 && response.statusCode < 300 {
                    completion(.success(data))
                    self.task = nil
                    if error != nil {
                        self.lastCode = nil
                    }
                } else if let error = error  {
                    completion(.failure(error))
                }
            }
        }
        self.task = task
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

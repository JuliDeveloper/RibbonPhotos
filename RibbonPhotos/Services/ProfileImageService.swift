//
//  ProfileImageService.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 16.01.2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private(set) var avatarURL: String?
    
    private func makeRequest(_ token: String, username: String) -> URLRequest {
        guard let url = URL(string: Constants.unsplashGetProfileImage + username) else { return URLRequest(url: URL(fileURLWithPath: "")) }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func fetchData(_ token: String, username: String, _ completion: @escaping (Result<Data, Error>) -> Void) {
//        assert(Thread.isMainThread)
//        task?.cancel()
        
        let request = makeRequest(token, username: username)
        let session = urlSession
        let task = session.dataTask(with: request) { data, _, error in
            if let data = data {
                completion(.success(data))
                //self.task = nil
            } else if let error = error {
                completion(.failure(error))
            }
        }
        
        //self.task = task
        task.resume()
    }
    
    func fetchProfileImageURL(_ token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        fetchData(token, username: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let images = try JSONDecoder().decode(ProfileImage.self, from: data)
                    self.avatarURL = images.small
                    print("111", "\(self.avatarURL ?? "")")
                    completion(.success(self.avatarURL ?? ""))
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": self.avatarURL ?? ""]
                        )
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

//
//  ProfileService.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 15.01.2023.
//

import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
}

final class ProfileService: ProfileServiceProtocol {
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private(set) var profile: Profile?
    
    private func convertFrom(profileResult: ProfileResult) -> Profile {
        let username = "\(profileResult.username ?? "")"
        let name = "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")"
        let loginName = "@\(profileResult.username ?? "")"
        let bio = "\(profileResult.bio ?? "")"
        
        return Profile(username: username, name: name, loginName: loginName, bio: bio)
    }
    
    private func makeRequest(_ token: String) -> URLRequest {
        guard let url = URL(string: Constants.unsplashGetProfile) else { return URLRequest(url: URL(fileURLWithPath: "")) }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func fetchData(_ token: String, _ completion: @escaping (Result<Data, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let request = makeRequest(token)
        let session = urlSession
        let task = session.dataTask(with: request) { data, _, error in
            if let data = data {
                completion(.success(data))
                self.task = nil
            } else if let error = error {
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        fetchData(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let profileInfo = try JSONDecoder().decode(ProfileResult.self, from: data)
                    let currentProfile = self.convertFrom(profileResult: profileInfo)
                    self.profile = currentProfile
                    completion(.success(self.profile ?? Profile(
                        username: "failure",
                        name: "failure",
                        loginName: "failure",
                        bio: "failure"
                    )))
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

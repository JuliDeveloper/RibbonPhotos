//
//  ImagesListService.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 23.01.2023.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private let token = OAuth2TokenStorage().bearerToken
    
    func fetchPhotosNextPage() {
        guard task == nil,
              let lastPage = lastLoadedPage
        else { return }
        
        let nextPage = lastLoadedPage == nil ? 1 : lastPage + 1
        
        guard var urlComponents = URLComponents(string: Constants.unsplashGetListPhotos) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(nextPage)")
        ]
        
        guard let url = urlComponents.url,
              let token = token
        else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = urlSession
        let task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let responsePhotos):
                    let currentPhotos = responsePhotos.map { $0.convert() }
                    self.photos.append(contentsOf: currentPhotos)
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self
                    )
                case .failure(let error):
                    print(error)
                }
            }
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
}

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
    
    private func convertFrom(photoResult: PhotoResult) -> Photo {
        let id = photoResult.id
        let size = CGSize(width: photoResult.width, height: photoResult.height)
        let createdAt = DateFormatter().date(from: photoResult.createdAt ?? "")
        let welcomeDescription = photoResult.description ?? ""
        let thumbImageURL = photoResult.urls?.thumb
        let largeImageURL = photoResult.urls?.full
        let isLiked = photoResult.likedByUser
        
        return Photo(
            id: id,
            size: size,
            createdAt: createdAt,
            welcomeDescription: welcomeDescription,
            thumbImageURL: thumbImageURL ?? "",
            largeImageURL: largeImageURL ?? "",
            isLiked: isLiked
        )
    }
    
    func fetchPhotosNextPage(_ completion: @escaping (Result<[Photo], Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let nextPage = lastLoadedPage == nil
            ? 1
            : lastLoadedPage ?? 0 + 1
        
        guard let url = URL(string: Constants.unsplashGetListPhotos) else { return }
        
        let request = URLRequest(url: url)
        let session = urlSession
        let task = session.objectTask(for: request) { [weak self] (result: Result<PhotoResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let photoResult):
                let currentPhoto = self.convertFrom(photoResult: photoResult)
                
                DispatchQueue.main.async {
                    self.photos.append(currentPhoto)
                }
                completion(.success(self.photos))
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["photos": self.photos]
                )
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
}

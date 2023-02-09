//
//  ImageListViewPresenter.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 09.02.2023.
//

import Foundation

protocol ImageListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func sendArrayPhotos() -> [Photo]
    func sendPhotosNextPage()
    func sendChangedLike(photo: Photo, completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImageListViewPresenter: ImageListViewPresenterProtocol {
    //MARK: - Properties
    private let imageListService: ImagesListService?
    weak var view: ImagesListViewControllerProtocol?
    
    //MARK: - LifeCycle
    init(viewController: ImagesListViewControllerProtocol) {
        self.imageListService = ImagesListService.shared
    }
    
    //MARK: - Functions
    func sendArrayPhotos() -> [Photo] {
        imageListService?.photos ?? []
    }
    
    func sendPhotosNextPage() {
        imageListService?.fetchPhotosNextPage()
    }
    
    func sendChangedLike(photo: Photo, completion: @escaping (Result<Void, Error>) -> Void) {
        imageListService?.changeLike(photoId: photo.id, isLike: photo.isLiked, completion)
    }
}

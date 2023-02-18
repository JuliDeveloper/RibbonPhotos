//
//  ImageListViewTest.swift
//  RibbonPhotosTests
//
//  Created by Julia Romanenko on 09.02.2023.
//

@testable import RibbonPhotos
import XCTest

final class ImageListViewPresenterSpy: ImageListViewPresenterProtocol {
    var loadPhotosNextPagesCalled = false
    var changeLikeCalled = false
    var view: ImagesListViewControllerProtocol?
    
    func getPhotos() -> [Photo] {
        return [Photo]()
    }
    
    func sendPhotosNextPage() {
        loadPhotosNextPagesCalled = true
    }
    
    func sendChangedLike(photo: Photo, completion: @escaping (Result<Void, Error>) -> Void) {
        changeLikeCalled = true
    }
    
    
}

final class ImageListViewTest: XCTestCase {
    func testFetchArrayPhotos() {
        let viewController = ImagesListViewController()
        let presenter = ImageListViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        let photos = presenter.getPhotos()
        
        XCTAssertNotNil(photos)
    }
    
    func testFetchPhotosNextPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? UITabBarController else { return }
        guard let viewController = tabBarController.viewControllers?[0] as? ImagesListViewController else { return }
        let presenter = ImageListViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        viewController.presenter?.sendPhotosNextPage()
        
        XCTAssertTrue(presenter.loadPhotosNextPagesCalled)
    }
    
    func testChangeLike() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else { return }
        let presenter = ImageListViewPresenterSpy()
        let photo = Photo(
            id: "",
            size: CGSize(),
            createdAt: Date(),
            welcomeDescription: "",
            thumbImageURL: "",
            largeImageURL: "",
            isLiked: Bool()
        )
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        viewController.presenter?.sendChangedLike(photo: photo, completion: { _ in })
        
        XCTAssertTrue(presenter.changeLikeCalled)
    }
}

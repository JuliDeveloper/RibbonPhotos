@testable import RibbonPhotos
import XCTest

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    func sendProfile() -> Profile? {
        return Profile()
    }
    
    func sendUrlAvatar() -> URL? {
        return URL(string: "testString")
    }
    
    func logout() {
        
    }
}

final class ProfileViewTest: XCTestCase {
    func testFetchProfileInfo() {
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()

        viewController.presenter = presenter
        presenter.view = viewController

        let profile = presenter.sendProfile()

        XCTAssertNotNil(profile)
    }

    func testFetchAvatarUrl() {
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()

        viewController.presenter = presenter
        presenter.view = viewController
        
        let url = presenter.sendUrlAvatar()
        
        XCTAssertEqual(url, URL(string: "testString"))
    }

    func testLogout() {
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        let oAuth2TokenStorage = OAuth2TokenStorage()

        viewController.presenter = presenter
        presenter.view = viewController

        presenter.logout()
        let token = oAuth2TokenStorage.bearerToken

        XCTAssertEqual(token, nil)
    }
}

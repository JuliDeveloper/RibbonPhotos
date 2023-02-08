//
//  ProfileViewPresenter.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 08.02.2023.
//

import Foundation

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func sendProfile() -> Profile?
    func sendUrlAvatar() -> URL?
    func logout()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    private let profileService: ProfileService?
    private let profileImageService: ProfileImageService?
    private let oAuth2TokenStorage: OAuth2TokenStorage?
    
    weak var view: ProfileViewControllerProtocol?
    
    init(viewController: ProfileViewControllerProtocol) {
        profileService = ProfileService.shared
        profileImageService = ProfileImageService.shared
        oAuth2TokenStorage = OAuth2TokenStorage()
    }
    
    func sendProfile() -> Profile? {
        let profile = profileService?.profile
        return profile
    }
    
    func sendUrlAvatar() -> URL? {
        let imageUrl = profileImageService?.avatarURL ?? ""
        let url = URL(string: imageUrl)
        return url
    }
    
    func logout() {
        oAuth2TokenStorage?.bearerToken = nil
        WebViewViewController.clean()
    }
}

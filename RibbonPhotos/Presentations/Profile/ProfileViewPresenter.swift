//
//  ProfileViewPresenter.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 08.02.2023.
//

import Foundation

protocol ProfileViewPresenterProtocol {
    func sendProfile() -> Profile?
    func sendUrlAvatar() -> URL?
    func logout()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    //MARK: - Properties
    private let profileService: ProfileService
    private let profileImageService: ProfileImageService
    private let oAuth2TokenStorage: OAuth2TokenStorage
    
    weak var view: ProfileViewControllerProtocol?
    
    //MARK: - LifeCycle
    init(
        viewController: ProfileViewControllerProtocol,
        profileService: ProfileService = .shared,
        profileImageService: ProfileImageService = .shared,
        oAuth2TokenStorage: OAuth2TokenStorage = OAuth2TokenStorage()
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.oAuth2TokenStorage = oAuth2TokenStorage
    }
    
    //MARK: - Functions
    func sendProfile() -> Profile? {
        let profile = profileService.profile
        return profile
    }
    
    func sendUrlAvatar() -> URL? {
        let imageUrl = profileImageService.avatarURL ?? ""
        let url = URL(string: imageUrl)
        return url
    }
    
    func logout() {
        oAuth2TokenStorage.bearerToken = nil
        WebViewViewController.clean()
    }
}

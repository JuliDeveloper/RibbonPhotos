//
//  SplashViewController.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 08.01.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    //MARK: - Properties
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash_screen_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    //MARK: - LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupConfigurationUI()
        showUserScenario()
    }
    
    //MARK: - Helpers
    private func setupConfigurationUI() {
        view.backgroundColor = .ypBlack
        
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func prepare() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
               .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    private func showUserScenario() {
        if let token = oauth2TokenStorage.bearerToken {
            fetchProfile(token: token)
        } else {
            prepare()
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let profile):
                    self.profileImageService.fetchProfileImageURL(token, username: profile.username ?? "") { _ in }
                    self.switchToTabBarController()
                case .failure:
                    self.showAlert { _ in
                        self.prepare()
                    }
                    break
                }
            }
            
        }
    }
}

//MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate() {
        self.showUserScenario()
        UIBlockingProgressHUD.dismiss()
    }
}

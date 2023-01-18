//
//  SplashViewController.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 08.01.2023.
//

import UIKit

fileprivate let showAuthIdentifier = "showAuth"

final class SplashViewController: UIViewController {
    //MARK: - Properties
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    //MARK: - LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showUserScenario()
    }
    
    //MARK: - Helpers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                fatalError("Failed to prepare for \(showAuthIdentifier)")
            }
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
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
        if oauth2TokenStorage.bearerToken != nil {
            switchToTabBarController()
            fetchProfile(token: oauth2TokenStorage.bearerToken ?? "")
        } else {
            performSegue(withIdentifier: showAuthIdentifier, sender: nil)
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let profile):
                    self.profileImageService.fetchProfileImageURL(token, username: profile.username ?? "") { _ in }
                case .failure:
                    self.showAlert()
                    break
                }
            }
            
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}

//MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(vc: WebViewViewController) {
        UIBlockingProgressHUD.show()
        vc.dismiss(animated: true) {
            self.showUserScenario()
            UIBlockingProgressHUD.dismiss()
        }
    }
}

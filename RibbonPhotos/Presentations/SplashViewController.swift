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
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    //MARK: - LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = oauth2TokenStorage.bearerToken {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthIdentifier, sender: nil)
        }
    }
    
    //Helpers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.topViewController as? AuthViewController
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
}

//MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        switchToTabBarController()
    }
}

//
//  AuthViewController.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 06.01.2023.
//

import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate()
}

fileprivate let showWebViewSegueIdentifier = "ShowWebView"

final class AuthViewController: UIViewController {
    //MARK: - Properties
    private let oAuth2Service = OAuth2Service()
    private var oAuth2TokenStorage = OAuth2TokenStorage()
    
    weak var delegate: AuthViewControllerDelegate?
    
    //MARK: - Helpers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                fatalError("Failed to prepare for \(showWebViewSegueIdentifier)")
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func saveAccessToken(_ accessToken: String) {
        oAuth2TokenStorage.bearerToken = accessToken
    }
}

//MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        oAuth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let accessToken):
                    self.saveAccessToken(accessToken)
                    self.delegate?.didAuthenticate()
                    ProgressHUD.dismiss()
                case .failure(let error):
                    print(error)
                    ProgressHUD.dismiss()
                }
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

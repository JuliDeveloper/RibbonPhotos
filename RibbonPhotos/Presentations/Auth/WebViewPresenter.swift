//
//  WebViewPresenter.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 03.02.2023.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    var helper: AuthHelperProtocol
    private let authConfiguration = AuthConfiguration.standard
    
    init(helper: AuthHelperProtocol) {
        self.helper = helper
    }
    
    func viewDidLoad() {
        let request = helper.authRequest()
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        helper.code(from: url)
    }
}

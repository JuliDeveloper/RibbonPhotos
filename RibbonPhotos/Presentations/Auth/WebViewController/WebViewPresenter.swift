//
//  WebViewPresenter.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 03.02.2023.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
}

class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
}

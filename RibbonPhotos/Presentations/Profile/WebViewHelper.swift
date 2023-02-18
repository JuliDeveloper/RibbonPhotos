//
//  WebViewHelper.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 18.02.2023.
//

import Foundation

protocol WebViewHelperProtocol {
    func cleanCookies()
}

final class WebViewHelper: WebViewHelperProtocol {
    func cleanCookies() {
        WebViewViewController.clean()
    }
}

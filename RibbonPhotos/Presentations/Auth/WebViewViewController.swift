//
//  WebViewViewController.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 06.01.2023.
//

import WebKit

final class WebViewViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    
    private let identifier = "ShowWebView"
    
    @IBAction private func didTapBackButton(_ sender: UIButton?) {}
}

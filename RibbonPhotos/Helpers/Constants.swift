//
//  Constants.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 29.12.2022.
//

import Foundation

enum Constants {
    static let accessKey = "X1GaI9onDFAezERyuwGOfq4lezFJvZ7l78iW2YkJdyQ"
    static let secretKey = "MML8fojUnCLRTULAWzMWna99Ba8P38ZwUiv9qS178UM"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

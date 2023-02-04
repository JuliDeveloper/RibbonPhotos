//
//  AuthConfiguration.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 29.12.2022.
//

import Foundation

let baseAccessKey = "X1GaI9onDFAezERyuwGOfq4lezFJvZ7l78iW2YkJdyQ"
let baseSecretKey = "MML8fojUnCLRTULAWzMWna99Ba8P38ZwUiv9qS178UM"
let baseRedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let baseAccessScope = "public+read_user+write_likes"

let baseDefaultBaseURL = URL(string: "https://api.unsplash.com")
let baseUnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
let baseUnsplashAuthorizeTokenURLString = "https://unsplash.com/oauth/token"
let baseUnsplashGetProfile = "https://api.unsplash.com/me"
let baseUnsplashGetProfileImage = "https://api.unsplash.com/users/"
let baseUnsplashGetListPhotos = "https://api.unsplash.com/photos"


struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let unsplashAuthorizeURLString: String
    let unsplashAuthorizeTokenURLString: String
    let unsplashGetProfile: String
    let unsplashGetProfileImage: String
    let unsplashGetListPhotos: String
    
    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        defaultBaseURL: URL,
        unsplashAuthorizeURLString: String,
        unsplashAuthorizeTokenURLString: String,
        unsplashGetProfile: String,
        unsplashGetProfileImage: String,
        unsplashGetListPhotos: String
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
        self.unsplashAuthorizeTokenURLString = unsplashAuthorizeTokenURLString
        self.unsplashGetProfile = unsplashGetProfile
        self.unsplashGetProfileImage = unsplashGetProfileImage
        self.unsplashGetListPhotos = unsplashGetListPhotos
    }
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(
            accessKey: baseAccessKey,
            secretKey: baseSecretKey,
            redirectURI: baseRedirectURI,
            accessScope: baseAccessScope,
            defaultBaseURL: baseDefaultBaseURL ?? URL(fileURLWithPath: ""),
            unsplashAuthorizeURLString: baseUnsplashAuthorizeURLString,
            unsplashAuthorizeTokenURLString: baseUnsplashAuthorizeTokenURLString,
            unsplashGetProfile: baseUnsplashGetProfile,
            unsplashGetProfileImage: baseUnsplashGetProfileImage,
            unsplashGetListPhotos: baseUnsplashGetListPhotos
        )
    }
}

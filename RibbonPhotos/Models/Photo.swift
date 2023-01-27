//
//  Photo.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 23.01.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}

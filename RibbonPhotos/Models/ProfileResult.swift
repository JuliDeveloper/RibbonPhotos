//
//  ProfileResult.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 15.01.2023.
//

import Foundation

struct ProfileResult: Codable {
    let username: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

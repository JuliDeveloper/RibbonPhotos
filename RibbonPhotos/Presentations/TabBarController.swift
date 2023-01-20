//
//  TabBarController.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 20.01.2023.
//

import UIKit
 
final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imageListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        
        let profileViewController = ProfileViewController()
        
        profileViewController.tabBarItem = UITabBarItem(
                    title: nil,
                    image: UIImage(named: "tab_profile_active"),
                    selectedImage: nil
                )
        profileViewController.tabBarItem.imageInsets = UIEdgeInsets(
            top: 5, left: 0,
            bottom: -5, right: 0
        )
        
        self.viewControllers = [imageListViewController, profileViewController]
    }
}

//
//  ProfileViewController.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 01.12.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var avatarImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var socialNetworkLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func logout(_ sender: UIButton) {
    }
}

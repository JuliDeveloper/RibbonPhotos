//
//  ImagesListCell.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 22.11.2022.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"
    
    func createGradient(for view: UIView) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.ypBlack.withAlphaComponent(0).cgColor,
                           UIColor.ypBlack.withAlphaComponent(0.2).cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
}

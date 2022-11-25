//
//  ImagesListCell.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 22.11.2022.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet private weak var imageCell: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var dateLabel: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"
    
    private let gradient = CAGradientLayer()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func layoutSublayers(of layer: CALayer) {
        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor.ypBlack.withAlphaComponent(0).cgColor,
                           UIColor.ypBlack.withAlphaComponent(0.2).cgColor]
        gradientView.layer.insertSublayer(gradient, at: 1)
    }
    
    func configCell(for cell: ImagesListCell, from photosName: [String], with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }

        cell.imageCell.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())

        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "buttonNoActive") : UIImage(named: "buttonActive")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

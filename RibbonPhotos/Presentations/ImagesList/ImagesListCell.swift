//
//  ImagesListCell.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 22.11.2022.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    //MARK: - Properties
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
        formatter.locale = Locale(identifier: "ru_ru")
        return formatter
    }()
    
    //MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor.ypBlack.withAlphaComponent(0).cgColor,
                           UIColor.ypBlack.withAlphaComponent(0.2).cgColor]
        gradientView.layer.insertSublayer(gradient, at: 1)
    }
    
    //MARK: - Helpers
    func configCell(for cell: ImagesListCell, from photos: [Photo], with indexPath: IndexPath) {
        let imageUrl = photos[indexPath.row].thumbImageURL
        let url = URL(string: imageUrl)
        
        cell.imageCell.kf.indicatorType = .activity
        cell.imageCell.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder_list_photos")
        )
        cell.dateLabel.text = dateFormatter.string(from: photos[indexPath.row].createdAt ?? Date())

        let isLiked = photos[indexPath.row].isLiked
        let likeImage = isLiked ? UIImage(named: "buttonActive") : UIImage(named: "buttonNoActive")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

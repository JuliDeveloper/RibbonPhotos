//
//  SingleImageViewController.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 01.12.2022.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

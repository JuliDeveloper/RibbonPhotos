//
//  SingleImageViewController.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 01.12.2022.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    //MARK: - Properties
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    //MARK: - @IBActions
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

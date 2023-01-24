//
//  SingleImageViewController.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 01.12.2022.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    //MARK: - Properties
    var imageUrl: URL! {
        didSet {
            guard isViewLoaded else { return }
        }
    }
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImage()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 1.25
    }
    
    //MARK: - @IBActions
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        let activityVC = UIActivityViewController(activityItems: [imageView.image ?? UIImage()], applicationActivities: nil)
        activityVC.overrideUserInterfaceStyle = .dark
        present(activityVC, animated: true)
    }
    
    //MARK: - Helpers
    private func fetchImage() {
        imageView.kf.setImage(with: imageUrl) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func setupImage() {
        UIBlockingProgressHUD.show()
        fetchImage()
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func showError() {
        showDoubleAlert(
            title: "Что-то пошло не так.",
            message: "Попробовать ещё раз?",
            cancelAction: "Не надо",
            repeatAction: "Повторить"
        ) { [weak self] _ in
            self?.fetchImage()
        }
    }
}

//MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

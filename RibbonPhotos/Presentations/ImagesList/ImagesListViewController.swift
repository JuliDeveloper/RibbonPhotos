//
//  ViewController.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 22.11.2022.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    //MARK: - Properties
    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var photosName = [String]()
    private var photos: [Photo] = []
    
    private var imageListServiceObserver: NSObjectProtocol?
    
    lazy var presenter: ImageListViewPresenterProtocol = {
        ImageListViewPresenter(viewController: self)
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        photosName = Array(0..<20).map({ "\($0)" })
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        imageListServiceObserver = NotificationCenter.default
                    .addObserver(
                        forName: ImagesListService.didChangeNotification,
                        object: nil,
                        queue: .main
                    ) { [weak self] _ in
                        guard let self = self else { return }
                        self.updateTableViewAnimated()
                    }
        updateTableViewAnimated()
        presenter.sendPhotosNextPage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let singleVC = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath
            else { return }
            let selectedImageUrl = photos[indexPath.row].largeImageURL
            guard let url = URL(string: selectedImageUrl) else { return }
            singleVC.imageUrl = url
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func updateTableViewAnimated() {
        let currentCount = photos.count
        let newCount = presenter.getPhotos().count
        
        photos = presenter.getPhotos()
        
        if currentCount != newCount {
            tableView.performBatchUpdates {
                let newIndexPaths = (currentCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: newIndexPaths, with: .automatic)
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else { return UITableViewCell() }
        imageListCell.delegate = self
        imageListCell.configCell(for: imageListCell, from: photos, with: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        return imageListCell
    }
}

//MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            presenter.sendPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        presenter.sendChangedLike(photo: photo, completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.photos = self.presenter.getPhotos()
                    cell.setIsLiked(self.photos[indexPath.row].isLiked)
                case .failure(let error):
                    print(error)
                    self.showSingleAlert(
                        title: "Что-то пошло не так(",
                        message: "Попробуйте ещё раз",
                        nil
                    )
                }
                UIBlockingProgressHUD.dismiss()
            }
        })
    }
}

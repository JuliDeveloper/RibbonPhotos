//
//  ViewController.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 22.11.2022.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var photosName = [String]()
    private var photos: [Photo] = []
    
    private let imageListService = ImagesListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        photosName = Array(0..<20).map({ "\($0)" })
        
        tableView.dataSource = self
        tableView.delegate = self
        
        imageListServiceObserver = NotificationCenter.default
                    .addObserver(
                        forName: ImagesListService.didChangeNotification,
                        object: nil,
                        queue: .main
                    ) { [weak self] _ in
                        guard let self = self else { return }
                        self.updateTableViewAnimated()
                    }
        imageListService.fetchPhotosNextPage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UIBlockingProgressHUD.show()
        if segue.identifier == showSingleImageSegueIdentifier {
            let vc = segue.destination as? SingleImageViewController
            guard let indexPath = sender as? IndexPath else { return }
            let urlImage = photos[indexPath.row].largeImageURL
            let url = URL(string: urlImage)
            //vc?.
            UIBlockingProgressHUD.dismiss()
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func updateTableViewAnimated() {
        let currentCount = photos.count
        let newCount = imageListService.photos.count
        
        photos = imageListService.photos
        
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
        
        imageListCell.configCell(for: imageListCell, from: photos, with: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        return imageListCell
    }
}

//MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imageListService.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

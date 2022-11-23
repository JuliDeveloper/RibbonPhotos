//
//  ViewController.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 22.11.2022.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }


}

//MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else { return UITableViewCell() }
        
        imageListCell.configCell(for: imageListCell)
        
        return imageListCell
    }
}

//MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

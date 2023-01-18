//
//  UIViewController + Extension.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 18.01.2023.
//

import UIKit

extension UIViewController {
    func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}

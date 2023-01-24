//
//  UIViewController + Extension.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 18.01.2023.
//

import UIKit

extension UIViewController {
    func showSingleAlert(title: String, message: String, _ completion: ((UIAlertAction) -> (Void))?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: completion)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showDoubleAlert(title: String, message: String, cancelAction: String, repeatAction: String, _ completion: ((UIAlertAction) -> (Void))?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelAction, style: .cancel)
        let repeatAction = UIAlertAction(title: repeatAction, style: .default, handler: completion)
        
        alert.addAction(cancelAction)
        alert.addAction(repeatAction)
        present(alert, animated: true)
    }
}

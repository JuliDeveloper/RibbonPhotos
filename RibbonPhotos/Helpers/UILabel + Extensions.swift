//
//  UILabel + Extensions.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 13.12.2022.
//

import UIKit

extension UILabel {
    func config(for label: UILabel, text: String, fontSize: CGFloat, textColor: UIColor) {
        label.text = text
        label.font = UIFont(name: "YS Display", size: fontSize)
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false
    }
}

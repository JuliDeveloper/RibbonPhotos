//
//  Date + Extension.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 24.01.2023.
//

import Foundation

extension Date {    
    func convertStringToDate(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: string)
        return date
    }
}

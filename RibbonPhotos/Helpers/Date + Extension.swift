//
//  Date + Extension.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 24.01.2023.
//

import Foundation

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    formatter.locale = Locale(identifier: "ru_ru")
    return formatter
}()

extension Date {
    var dateTimeString: String { dateFormatter.string(from: self) }
    
    func convertStringToDate(_ string: String) -> Date? {
        let dateFormatter =  ISO8601DateFormatter()
        let date = dateFormatter.date(from: string)
        return date
    }
}

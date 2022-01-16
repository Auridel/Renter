//
//  Extension+DateFormatter.swift
//  Renter
//
//  Created by Oleg Efimov on 15.01.2022.
//

import Foundation

extension DateFormatter {
    public static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        return dateFormatter
    }()
    
    public static let displayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
}

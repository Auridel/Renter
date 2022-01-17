//
//  Extension+String.swift
//  Renter
//
//  Created by Oleg Efimov on 15.01.2022.
//

import UIKit

extension String {
    public func formattedDate() -> String {
        let date = DateFormatter.dateFormatter.date(from: self)
        guard let date = date else {
            print("cannot get date")
            return self
        }
        return DateFormatter.displayDateFormatter.string(from: date)
    }
    
    //TODO: Extension to parse date
}

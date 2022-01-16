//
//  HistoryTableViewCell.swift
//  Renter
//
//  Created by Oleg Efimov on 16.01.2022.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    public static let identifier = "HistoryTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

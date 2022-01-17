//
//  EntryDetailsHeaderView.swift
//  Renter
//
//  Created by Oleg Efimov on 17.01.2022.
//

import UIKit

class EntryDetailsHeaderView: UIView {
    
    private let title: String
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        return label
    }()

    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        
        titleLabel.text = title
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 16,
                                  y: 8,
                                  width: width,
                                  height: 30)
    }
    
}

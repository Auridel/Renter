//
//  AccountTableViewCell.swift
//  Renter
//
//  Created by Oleg Efimov on 19.01.2022.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    
    public static let identifier = "AccountTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .label
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 16,
                             y: (contentView.height - 25) / 2,
                             width: contentView.width - 32,
                             height: 25)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        label.textColor = .label
    }
    
    public func configure(with viewModel: AccountRowViewModel) {
        label.text = viewModel.content
        label.textColor = viewModel.color
    }
}

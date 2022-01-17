//
//  EntryDetailsTableViewCell.swift
//  Renter
//
//  Created by Oleg Efimov on 17.01.2022.
//

import UIKit

class EntryDetailsTableViewCell: UITableViewCell {

    public static let identifier = "EntryDetailsTableViewCell"
    
    private var viewModel: EntryRowViewModel?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 16,
                                  y: 8,
                                  width: contentView.width / 2 - 16,
                                  height: 22)
        valueLabel.frame = CGRect(x: contentView.width / 2,
                                  y: 8,
                                  width: contentView.width / 2 - 16,
                                  height: 22)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        valueLabel.text = nil
    }
    
    public func configure(with viewModel: EntryRowViewModel) {
        self.viewModel = viewModel
        DispatchQueue.main.async {
            self.titleLabel.text = viewModel.title
            self.valueLabel.text = viewModel.value
        }
    }
}

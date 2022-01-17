//
//  HistoryTableViewCell.swift
//  Renter
//
//  Created by Oleg Efimov on 16.01.2022.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    public static let identifier = "HistoryTableViewCell"
    
    private var viewModel: HistoryRowViewModel?
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .right
        return label
    }()
    
    // MARK: Lyfecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(priceLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateLabel.frame = CGRect(x: 16,
                                 y: 16,
                                 width: contentView.width / 2 - 32,
                                 height: 22)
        priceLabel.frame = CGRect(x: contentView.width / 2 + 16,
                                  y: 16,
                                  width: contentView.width / 2 - 32,
                                  height: 22)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        priceLabel.text = nil
    }
    
    //MARK: Common
    
    public func configure(with viewModel: HistoryRowViewModel) {
        self.viewModel = viewModel
        DispatchQueue.main.async { [weak self] in
            self?.dateLabel.text = self?.viewModel?.date ?? ""
            self?.priceLabel.text = self?.viewModel?.price
        }
    }
}

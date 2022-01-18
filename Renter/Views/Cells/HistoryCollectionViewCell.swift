//
//  HistoryCollectionViewCell.swift
//  Renter
//
//  Created by Oleg Efimov on 16.01.2022.
//

import UIKit

class HistoryCollectionViewCell: UICollectionViewCell {

    public static let identifier = "HistoryCollectionViewCell"
    
    private var viewModel: HistoryRowViewModel?
    
    private let expandImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "list.dash")
        imageView.tintColor = UIColor(
            red: 179 / 255,
            green: 229 / 255,
            blue: 252 / 255,
            alpha: 1)
        imageView.sizeToFit()
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .right
        return label
    }()
    
    // MARK: Lyfecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        styleCell()
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(expandImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = 50
        expandImageView.frame = CGRect(
            x: 16,
            y: (contentView.height - imageSize) / 2,
            width: imageSize,
            height: imageSize)
        dateLabel.frame = CGRect(x: contentView.width / 2 + 16,
                                 y: 16,
                                 width: contentView.width / 2 - 32,
                                 height: 22)
        priceLabel.frame = CGRect(x: contentView.width / 2 + 16,
                                  y: dateLabel.bottom + 8,
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
    
    private func styleCell() {
        contentView.backgroundColor = UIColor(red: 66 / 255, green: 165 / 255, blue: 245 / 255, alpha: 1)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.cyan.withAlphaComponent(0.4).cgColor
        contentView.layer.shadowOffset = CGSize(width: 5, height: 5)
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.cornerRadius = 6
        contentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
    }
}

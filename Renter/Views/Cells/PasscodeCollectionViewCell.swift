//
//  PasscodeCollectionViewCell.swift
//  Renter
//
//  Created by Oleg Efimov on 30.01.2022.
//

import UIKit

class PasscodeCollectionViewCell: UICollectionViewCell {
    
    public static let identifier = "PasscodeCollectionViewCell"
    
    private var viewModel: PasscodeCollectionViewCellViewModel?
    
    private let button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.setTitleColor(.label,
                             for: .normal)
        button.tintColor = .label
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        button.addTarget(self,
                         action: #selector(didTapButton),
                         for: .touchUpInside)
        
        contentView.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.frame = CGRect(
            x: 0,
            y: 0,
            width: contentView.width - 10,
            height: contentView.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        button.setTitle(nil, for: .normal)
        button.setImage(nil, for: .normal)
    }
    
    @objc private func didTapButton() {
        viewModel?.onPress()
    }
    
    public func configure(with viewModel: PasscodeCollectionViewCellViewModel) {
        self.viewModel = viewModel
        button.setTitle(viewModel.label, for: .normal)
        button.setImage(viewModel.image, for: .normal)
    }
}

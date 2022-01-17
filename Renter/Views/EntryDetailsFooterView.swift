//
//  EntryDetailsFooterView.swift
//  Renter
//
//  Created by Oleg Efimov on 17.01.2022.
//

import UIKit

protocol EntryDetailsFooterViewDelegate: AnyObject {
    func entryDetailsFooterViewDidTapCloseButton()
    func entryDetailsFooterViewDidTapDeleteButton()
}

class EntryDetailsFooterView: UIView {
    
    weak var delegate: EntryDetailsFooterViewDelegate?

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.imageView?.image = UIImage(systemName: "trash")
        button.imageView?.tintColor = .red
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.imageView?.image = UIImage(systemName: "xmark")
        button.imageView?.tintColor = .link
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        addSubview(deleteButton)
        addSubview(closeButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        deleteButton.frame = CGRect(x: 16,
                                    y: 8,
                                    width: 100,
                                    height: 55)
        closeButton.frame = CGRect(x: width - 100 - 16,
                                   y: 8,
                                   width: 100,
                                   height: 55)
    }
    
    // MARK: Actions
    
    @objc private func didTapCloseButton() {
        delegate?.entryDetailsFooterViewDidTapCloseButton()
    }
    
    @objc private func didTapDeleteButton() {
        delegate?.entryDetailsFooterViewDidTapDeleteButton()
    }
}

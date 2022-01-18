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
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.setTitle("Delete", for: .normal)
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 10
        configuration.baseForegroundColor = .red
        button.configuration = configuration
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.setTitle("Close", for: .normal)
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 10
        configuration.baseForegroundColor = .link
        button.configuration = configuration
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        closeButton.addTarget(self,
                              action: #selector(didTapCloseButton),
                              for: .touchUpInside)
        deleteButton.addTarget(self,
                               action: #selector(didTapDeleteButton),
                               for: .touchUpInside)
        
        addSubview(deleteButton)
        addSubview(closeButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        deleteButton.frame = CGRect(x: 16,
                                    y: 16,
                                    width: 120,
                                    height: 30)
        closeButton.frame = CGRect(x: width - 120 - 16,
                                   y: 16,
                                   width: 120,
                                   height: 30)
    }
    
    // MARK: Actions
    
    @objc private func didTapCloseButton() {
        delegate?.entryDetailsFooterViewDidTapCloseButton()
    }
    
    @objc private func didTapDeleteButton() {
        delegate?.entryDetailsFooterViewDidTapDeleteButton()
    }
}

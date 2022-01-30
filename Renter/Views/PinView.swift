//
//  PinView.swift
//  Renter
//
//  Created by Oleg Efimov on 30.01.2022.
//

import UIKit

class PinView: UIView {
    
    private let pin = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(pin)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pin.frame = CGRect(
            x: 5,
            y: 5,
            width: 20,
            height: 20)
    }
    
    public func selectPin() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.pin.backgroundColor = .label
            }
        }
    }
    
    public func deselectPin() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.pin.backgroundColor = .clear
            }
        }
    }
    
    private func configure() {
        pin.layer.masksToBounds = true
        pin.layer.borderWidth = 1
        pin.layer.cornerRadius = 10
        pin.layer.borderColor = UIColor.label.cgColor
    }
}

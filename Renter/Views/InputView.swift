//
//  InputView.swift
//  Renter
//
//  Created by Oleg Efimov on 15.01.2022.
//

import UIKit

class InputView: UIView {
    
    weak var delegate: UITextFieldDelegate?

    private let inputLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = Constants.primaryColor
        return label
    }()
    
    private let inputTextField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Constants.primaryColor.cgColor
        textField.leftView = UIView(
            frame: CGRect(x: 0,
                          y: 0,
                          width: 5,
                          height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    init(_ label: String, returnKey: UIReturnKeyType) {
        super.init(frame: .zero)
        inputLabel.text = label
        inputTextField.returnKeyType = returnKey
        
        addSubview(inputLabel)
        addSubview(inputTextField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        inputLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: 20)
        inputTextField.frame = CGRect(
            x: 0,
            y: inputLabel.bottom + 8,
            width: width,
            height: 50)
    }
    
    public func getValue() -> String? {
        inputTextField.text
    }
    
    public func clearInput() {
        inputTextField.text = nil
    }
}

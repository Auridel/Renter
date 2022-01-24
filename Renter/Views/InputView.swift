//
//  InputView.swift
//  Renter
//
//  Created by Oleg Efimov on 15.01.2022.
//

import UIKit

protocol InputViewDelegate: AnyObject {
    func inputViewTextFieldDidReturn(_ textField: UITextField, with label: String?, tag: String)
    func inputViewShouldBeginEditing(_ textField: UITextField) -> Bool
}

class InputView: UIView {
    
    weak var delegate: InputViewDelegate?
    
    public let inputTag: String
    
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
        textField.doneAccessory = true
        
        return textField
    }()
    
    init(_ label: String,
         returnKey: UIReturnKeyType,
         isSecure: Bool = false,
         keyboardType: UIKeyboardType = .default,
         tag: String = ""
    ) {
        self.inputTag = tag
        
        super.init(frame: .zero)
        inputLabel.text = label
        inputTextField.delegate = self
        inputTextField.isSecureTextEntry = isSecure
        inputTextField.returnKeyType = returnKey
        inputTextField.keyboardType = keyboardType
        
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
    
    public func setInputValue(_ value: String?) {
        inputTextField.text = value
    }
    
    public func getValue() -> String? {
        inputTextField.text
    }
    
    public func clearInput() {
        inputTextField.text = nil
    }
    
    public func makeFirstResponder() {
        inputTextField.becomeFirstResponder()
    }
    
    public func setError(_ isError: Bool) {
        inputTextField.layer.borderColor = isError ? UIColor.red.cgColor : Constants.primaryColor.cgColor
    }
    
}


extension InputView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.inputViewShouldBeginEditing(textField) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.inputViewTextFieldDidReturn(textField, with: inputLabel.text, tag: inputTag)
        
        return true
    }
}

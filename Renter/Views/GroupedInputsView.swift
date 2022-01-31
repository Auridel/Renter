//
//  GroupedInputView.swift
//  Renter
//
//  Created by Oleg Efimov on 23.01.2022.
//

import UIKit

struct GroupedInput {
    let title: String
    let tag: String
}

struct GroupedInputsViewModel {
    let title: String
    let inputs: [GroupedInput]
}

class GroupedInputView: UIView {
    
    public var blockHeight: CGFloat {
        CGFloat(ceil(Double(inputs.count) / 2)) * (inputHeight + lineSpacing) + 34 + 50
    }
    
    private var hasErrors = false
    
    private let lineSpacing: CGFloat = 24
    
    private let inputHeight: CGFloat = 70
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private var inputs = [InputView]()

    required init(title: String, inputs: [GroupedInput]) {
        super.init(frame: .zero)
        
        self.inputs = inputs.compactMap({
            InputView(
                $0.title,
                returnKey: $0.tag == inputs.last?.tag ? .done : .next,
                keyboardType: .decimalPad,
                tag: $0.tag)
        })
        self.titleLabel.text = title
        
        addSubview(titleLabel)
        addSubview(errorLabel)
        for input in self.inputs {
            input.delegate = self
            addSubview(input)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 16
        let rightInputX = width / 2  + padding
        let inputWidth = width / 2 - padding * 2
        
        
        titleLabel.frame = CGRect(
            x: padding,
            y: 0,
            width: width - padding * 2,
            height: 26)
        
        var counter = 1
        var rowInput: InputView?
        for input in inputs {
            let isEven = counter % 2 == 0
            input.frame = CGRect(
                x: isEven ? rightInputX : 16,
                y: counter < 3 ?
                    titleLabel.bottom + lineSpacing
                        : (rowInput?.bottom ?? titleLabel.bottom) + lineSpacing,
                width: inputWidth,
                height: inputHeight)
            if isEven {
                rowInput = input
            }
            counter += 1
        }
        errorLabel.frame = CGRect(
            x: padding,
            y: (inputs.last?.bottom ?? titleLabel.bottom) + padding,
            width: width - padding * 2,
            height: 18)
    }
    
    public func setValues(_ values: [String: String]) {
        for (key, value) in values {
            if let input = inputs.first(where: { $0.inputTag == key }) {
                input.setInputValue(value)
            }
        }
    }
    
    public func getValues() -> [String: String] {
        var result = [String: String]()
        for input in inputs {
            result[input.inputTag] = input.getValue()
        }
        
        return result
    }
    
    public func validate() -> Bool {
        for input in inputs {
            let value = input.getValue()
            if (value ?? "").isEmpty  {
                DispatchQueue.main.async {
                    input.setError(true)
                    self.hasErrors = true
                    self.errorLabel.text  = "Fields cannot be empty!"
                }
            }
        }
        return !hasErrors
    }
}


// MARK: InputViewDelegate
extension GroupedInputView: InputViewDelegate {
    func inputViewTextFieldDidReturn(_ textField: UITextField, with label: String?, tag: String) {
        guard let index = inputs.firstIndex(where: { $0.inputTag == tag })
        else {
            textField.resignFirstResponder()
            return
        }
        if index == inputs.endIndex {
            textField.resignFirstResponder()
        } else {
            inputs[index + 1].becomeFirstResponder()
        }
    }
    
    func inputViewShouldBeginEditing(_ textField: UITextField) -> Bool {
        if hasErrors {
            for input in inputs {
                DispatchQueue.main.async {
                    input.setError(false)
                }
            }
            hasErrors = false
            DispatchQueue.main.async {
                self.errorLabel.text = nil
            }
        }
        return true
    }
    
    
}

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
        for input in self.inputs {
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
}

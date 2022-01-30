//
//  GroupedPinView.swift
//  Renter
//
//  Created by Oleg Efimov on 30.01.2022.
//

import UIKit

class GroupedPinView: UIView {
    
    private var selectedCount = 0
    
    private let pins: [PinView] = Array(0..<4).map({ _ in PinView() })

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for pin in pins {
            addSubview(pin)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let pinSize: CGFloat = 40
        let totalSize: CGFloat = pinSize * 4
        let startPosition: CGFloat = width > totalSize ? width / 2 - totalSize / 2 : 0
        
        var prevPin: PinView?
        
        for pin in pins {
            pin.frame = CGRect(
                x: prevPin?.right ?? startPosition,
                y: height / 2 - pinSize / 2,
                width: pinSize,
                height: pinSize)
            prevPin = pin
        }
    }
    
    public func updatePins(selectedCount: Int) {
        if self.selectedCount != selectedCount {
            self.selectedCount = selectedCount
            var counter = 1
            
            for pin in pins {
                if counter <= selectedCount {
                    pin.selectPin()
                } else {
                    pin.deselectPin()
                }
                counter += 1
            }
        }
    }
    
}

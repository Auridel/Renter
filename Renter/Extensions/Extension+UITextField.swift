//
//  Extension+UITextField.swift
//  Renter
//
//  Created by Oleg Efimov on 16.01.2022.
//

import UIKit

extension UITextField {
    
    @IBInspectable var doneAccessory: Bool {
        get {
            return self.doneAccessory
        } set(hasDone) {
            if hasDone {
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 55))
        doneToolbar.barStyle = .default
        doneToolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(didTapDoneButton))
        
        doneToolbar.items = [flexSpace, doneButton]
        
        inputAccessoryView = doneToolbar
    }
    
    @objc func didTapDoneButton() {
        self.resignFirstResponder()
    }
}

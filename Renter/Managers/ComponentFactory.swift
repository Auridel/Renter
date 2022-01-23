//
//  ComponentFactory.swift
//  Renter
//
//  Created by Oleg Efimov on 23.01.2022.
//

import UIKit

class ComponentFactory {
    
    public static let shared = ComponentFactory()
    
    private init() {}
    
    public func produceUIAlert(with title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .cancel,
                                      handler: nil))
        return alert
    }
    
    public func produceUIAlert(with title: String, message: String, action: UIAlertAction) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(action)
        
        return alert
    }
    
    public func produceUIAlert(with title: String, message: String?, action: UIAlertAction, textFieldValue: String?, placeholder: String?) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = textFieldValue
            textField.placeholder = placeholder
        }
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(action)
        
        return alert
    }
}

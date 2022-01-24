//
//  RegisterPresenter.swift
//  Renter
//
//  Created by Oleg Efimov on 23.01.2022.
//

import Foundation
import UIKit

protocol RegisterPresenterDelegate: AnyObject {
    func presentAlert(with title: String, message: String)
    func onRegisterSuccess()
}

class RegisterPresenter {
    
    typealias RegisterPresenterDelegateType = UIViewController & RegisterPresenterDelegate
    
    weak var delegate: RegisterPresenterDelegateType?
    
    public func registerUser(with email: String?, name: String?, password: String?, confirm: String?) {
        guard let email = email,
              let name = name,
              let password = password,
              let confirm = confirm,
              !email.isEmpty,
              !name.isEmpty,
              !password.isEmpty,
              !confirm.isEmpty
        else {
            DispatchQueue.main.async {
                self.delegate?.presentAlert(with: "Error",
                                       message: "Fields must not be empty!")
            }
            return
        }
        
        
        AuthManager.shared.register(
            with: email,
            name: name,
            password: password,
            confirm: confirm) { [weak self] message in
                DispatchQueue.main.async {
                    self?.delegate?.presentAlert(with: "Message",
                                                 message: message)
                }
            }
    }
}

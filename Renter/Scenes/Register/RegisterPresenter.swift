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
    
    public func registerUser(with email: String, name: String, password: String, confirm: String) {
        AuthManager.shared.register(
            with: email,
            name: name,
            password: password,
            confirm: confirm) { isSuccess in
                if isSuccess {
                    
                } else {
                    
                }
            }
    }
}

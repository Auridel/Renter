//
//  LoginPresenter.swift
//  Renter
//
//  Created by Oleg Efimov on 16.01.2022.
//

import Foundation
import UIKit

protocol LoginPresenterDelegate: AnyObject {
    func presentAlert(with error: String)
    func onLoginSuccess()
}

final class LoginPresenter {
    
    weak var delegate: LoginPresenterDelegateType?
    
    typealias LoginPresenterDelegateType = UIViewController & LoginPresenterDelegate
    
    public func setPresenterDelegate(_ delegate: LoginPresenterDelegateType) {
        self.delegate = delegate
    }
    
    public func proceedToLogin(with email: String, password: String) {
        AuthManager.shared.login(with: email, password: password) { [weak self] isSuccess in
            if isSuccess {
                self?.delegate?.onLoginSuccess()
            } else {
                self?.delegate?.presentAlert(with: "Failed To Login")
            }
        }
    }
}

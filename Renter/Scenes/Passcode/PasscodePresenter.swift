//
//  PasscodePresenter.swift
//  Renter
//
//  Created by Oleg Efimov on 30.01.2022.
//

import UIKit

protocol PasscodePresenterDelegate: AnyObject {
    func presentAlert(with message: String)
    func passcodePresenterDidLogin()
}

class PasscodePresenter {
    
    typealias PasscodePresenterDelegateType = UIViewController & PasscodePresenterDelegate
    
    weak var delegate: PasscodePresenterDelegateType?
    
    public func didAuthorizeWithBiometric() {
        AuthManager.shared.loginWithBiometric { [weak self] result in
            self?.proceedWithAuthResult(result)
        }
    }
    
    public func didEnterPasscode(_ passcode: [Int]) {
        let passcodeString = passcode.reduce("") { $0 + "\($1)" }
        print(passcode)
        AuthManager.shared.loginWithPasscode(
            passcode: passcodeString) { [weak self] result in
                self?.proceedWithAuthResult(result)
            }
    }
    
    private func proceedWithAuthResult(_ result: AuthManager.PasscodeAuthResult) {
        switch result {
        case .invalidPasscode:
            self.delegate?.presentAlert(with: "Incorrect Passcode!")
        case .failedToGetKeychainValues:
            //TODO: to login
            break
        case .failedToAuth:
            self.delegate?.presentAlert(with: "Authorization Error!")
        case .success:
            delegate?.passcodePresenterDidLogin()
        }
    }
}

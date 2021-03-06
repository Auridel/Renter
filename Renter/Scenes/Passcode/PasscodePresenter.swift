//
//  PasscodePresenter.swift
//  Renter
//
//  Created by Oleg Efimov on 30.01.2022.
//

import UIKit

protocol PasscodePresenterDelegate: AnyObject {
    func passcodePresenterPresentAlert(with message: String)
    func passcodePresenterDidLogin()
    func passcodePresenterSetTitle(_ title: String)
    func passcodePresenterClearPasscode()
    func passcodePresenterKeychainFailure()
}

protocol PasscodePresenterProtocol: AnyObject {
    func didAuthorizeWithBiometric()
    func didEnterPasscode(_ passcode: [Int])
}

class PasscodePresenter: PasscodePresenterProtocol {
    
    typealias PasscodePresenterDelegateType = UIViewController & PasscodePresenterDelegate
    
    weak var delegate: PasscodePresenterDelegateType?
    
    public func didAuthorizeWithBiometric() {
        AuthManager.shared.loginWithBiometric { [weak self] result in
            self?.proceedWithAuthResult(result)
        }
    }
    
    public func didEnterPasscode(_ passcode: [Int]) {
        let passcodeString = passcode.reduce("") { $0 + "\($1)" }
        AuthManager.shared.login(
            passcode: passcodeString) { [weak self] result in
                self?.proceedWithAuthResult(result)
            }
    }
    
    private func proceedWithAuthResult(_ result: AuthManager.PasscodeAuthResult) {
        switch result {
        case .invalidPasscode:
            delegate?.passcodePresenterPresentAlert(with: "Incorrect Passcode!")
        case .failedToGetKeychainValues:
            delegate?.passcodePresenterKeychainFailure()
        case .failedToAuth:
            delegate?.passcodePresenterPresentAlert(with: "Authorization Error!")
        case .success:
            delegate?.passcodePresenterDidLogin()
        }
        delegate?.passcodePresenterClearPasscode()
    }
}

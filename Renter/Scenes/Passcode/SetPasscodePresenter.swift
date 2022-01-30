//
//  SetPasscodePresenter.swift
//  Renter
//
//  Created by Oleg Efimov on 30.01.2022.
//

import UIKit

class SetPasscodePresenter: PasscodePresenterProtocol {
        
    typealias PasscodePresenterDelegateType = UIViewController & PasscodePresenterDelegate
    
    weak var delegate: PasscodePresenterDelegateType?
    
    private var passcode: String = ""
    
    func didAuthorizeWithBiometric() {
        
    }
    
    public func didEnterPasscode(_ passcode: [Int]) {
        let passcodeString = passcode.reduce("") { $0 + "\($1)" }
        if self.passcode.isEmpty {
            self.passcode = passcodeString
            delegate?.passcodePresenterSetTitle("Repeat Passcode")
            delegate?.passcodePresenterClearPasscode()
            return
        }
        if self.passcode == passcodeString {
            AuthManager.shared.savePasscode(passcode: passcodeString)
            delegate?.passcodePresenterDidLogin()
        }
    }
}

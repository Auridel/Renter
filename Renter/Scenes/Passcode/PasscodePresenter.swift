//
//  PasscodePresenter.swift
//  Renter
//
//  Created by Oleg Efimov on 30.01.2022.
//

import UIKit

protocol PasscodePresenterDelegate: AnyObject {
    func didEnterPasscode(_ passcode: [Int])
    func presentAlert(with message: String)
}

class PasscodePresenter {
    
    typealias PasscodePresenterDelegateType = UIViewController & PasscodePresenterDelegate
    
    weak var delegate: PasscodePresenterDelegateType?
    
    public func didAuthorizeWithBiometric() {
        
    }
}

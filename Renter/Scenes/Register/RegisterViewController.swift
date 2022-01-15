//
//  RegisterViewController.swift
//  Renter
//
//  Created by Oleg Efimov on 15.01.2022.
//

import UIKit

protocol RegisterViewControllerDelegate: AnyObject {
    func didTapLogin()
    func didRegister()
}

class RegisterViewController: UIViewController {
    
    weak var delegate: RegisterViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
    }

}

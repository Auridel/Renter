//
//  LoginViewController.swift
//  Renter
//
//  Created by Oleg Efimov on 15.01.2022.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func didTapRegister()
    func didLogin()
}

class LoginViewController: UIViewController {
    
    weak var delegate: LoginViewControllerDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login"
        view.backgroundColor = .systemBackground

        configureViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutViews()
    }
    
    private func configureViews() {
        view.addSubview(label)
    }
    
    private func layoutViews() {
        label.frame = view.bounds
    }

}

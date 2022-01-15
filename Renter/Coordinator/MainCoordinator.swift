//
//  LoginCoordinator.swift
//  Renter
//
//  Created by Oleg Efimov on 15.01.2022.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    unowned var navigationController: UINavigationController
    
    var children: [Coordinator]?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        navigationController.viewControllers = [loginVC]
    }
}

// MARK: LoginViewControllerDelegate
extension MainCoordinator: LoginViewControllerDelegate {
    func didTapRegister() {
        let registerVC = RegisterViewController()
        registerVC.delegate = self
        self.navigationController.pushViewController(registerVC, animated: true)
    }
    
    func didLogin() {
        
    }
}

// MARK: RegisterViewControllerDelegate
extension MainCoordinator: RegisterViewControllerDelegate {
    func didTapLogin() {
        self.navigationController.popToRootViewController(animated: true)
    }
    
    func didRegister() {
        
    }
    
    
}

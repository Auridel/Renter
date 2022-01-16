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
    
    var observer: NSObjectProtocol?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.observer = NotificationCenter.default.addObserver(
            forName: .tokenExpired,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                // TODO: reset to login
                
            })
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
        self.navigationController.view.layer.add(Constants.fadeTransition, forKey: nil)
        self.navigationController.pushViewController(registerVC, animated: false)
    }
    
    func didLogin() {
        
    }
}

// MARK: RegisterViewControllerDelegate
extension MainCoordinator: RegisterViewControllerDelegate {
    func didTapLogin() {
        self.navigationController.view.layer.add(Constants.fadeTransition, forKey: nil)
        self.navigationController.popToRootViewController(animated: false)
    }
    
    func didRegister() {
        
    }
    
    
}

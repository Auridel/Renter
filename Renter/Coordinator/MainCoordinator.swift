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
    
    var mainTabViewController: MainTabsViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.observer = NotificationCenter.default.addObserver(
            forName: .tokenExpired,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.resetToLogin()
            })
    }
    
    func start() {
        DispatchQueue.main.async {
            if AuthManager.shared.isAuthorized {
                self.proceedToMain()
            } else {
                let loginVC = self.pickLoginVC()
                self.navigationController.viewControllers = [loginVC]
            }
        }
    }
    
    private func pickLoginVC() -> UIViewController {
        if AuthManager.shared.isKeychainDataExists {
            let loginVC = PasscodeViewController()
            let presenter = PasscodePresenter()
            presenter.delegate = loginVC
            loginVC.presenter = presenter
            loginVC.delegate = self
            return loginVC
        } else {
            let loginVC = LoginViewController()
            loginVC.delegate = self
            return loginVC
        }
    }
    
    private func resetToLogin() {
        DispatchQueue.main.async {
            self.mainTabViewController?.dismiss(animated: true)
            let loginVC = self.pickLoginVC()
            self.navigationController.viewControllers = [loginVC]
        }
    }
    
    private func proceedToMain() {
        DispatchQueue.main.async {
            self.mainTabViewController = MainTabsViewController()
            guard let tabVC = self.mainTabViewController else {
                return
            }
            tabVC.modalPresentationStyle = .fullScreen
            self.navigationController.present(
                tabVC,
                animated: true)
            self.navigationController.viewControllers.removeAll()
        }
    }
}

// MARK: LoginViewControllerDelegate
extension MainCoordinator: LoginViewControllerDelegate {
    func didTapRegister() {
        DispatchQueue.main.async {
            let registerVC = RegisterViewController()
            registerVC.delegate = self
            self.navigationController.view.layer.add(Constants.fadeTransition, forKey: nil)
            self.navigationController.pushViewController(registerVC, animated: false)
        }
    }
    
    func didLogin() {
        DispatchQueue.main.async {
            let passcodeVC = PasscodeViewController(
                title: "Create Passcode",
                allowFaceId: false)
            let presenter = SetPasscodePresenter()
            passcodeVC.presenter = presenter
            presenter.delegate = passcodeVC
            passcodeVC.delegate = self
            self.navigationController.viewControllers = [passcodeVC]
        }
    }
}

// MARK: RegisterViewControllerDelegate
extension MainCoordinator: RegisterViewControllerDelegate {
    func didTapLogin() {
        DispatchQueue.main.async {
            self.navigationController.view.layer.add(Constants.fadeTransition, forKey: nil)
            self.navigationController.popToRootViewController(animated: false)
        }
    }
    
    func didRegister() {
        DispatchQueue.main.async {
            let passcodeVC = PasscodeViewController(
                title: "Create Passcode",
                allowFaceId: false)
            let presenter = SetPasscodePresenter()
            passcodeVC.presenter = presenter
            presenter.delegate = passcodeVC
            passcodeVC.delegate = self
            self.navigationController.viewControllers = [passcodeVC]
        }
    }
}

// MARK: PasscodeViewControllerDelegate
extension MainCoordinator: PasscodeViewControllerDelegate {
    
    func passcodeViewControllerDidTapBack() {
        AuthManager.shared.signOut(true)
    }
    
    func passcodeViewControllerDidLogin() {
        proceedToMain()
    }
    
}

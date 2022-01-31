//
//  RegisterViewController.swift
//  Renter
//
//  Created by Oleg Efimov on 15.01.2022.
//

import UIKit
import ProgressHUD

protocol RegisterViewControllerDelegate: AnyObject {
    func didTapLogin()
    func didRegister()
}

class RegisterViewController: UIViewController {
    
    weak var delegate: RegisterViewControllerDelegate?
    
    private let presenter = RegisterPresenter()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bounces = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let nameInput = InputView(
        "Name",
        returnKey: .next)
    
    private let emailInput = InputView(
        "Email",
        returnKey: .next)
    
    private let passwordInput = InputView(
        "Password",
        returnKey: .next,
        isSecure: true)
    
    private let repeatPasswordInput = InputView(
        "Repeat Password",
        returnKey: .done,
        isSecure: true)
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.primaryColor
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(Constants.primaryColor, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Register"
        view.backgroundColor = .systemBackground
        presenter.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustForKeyboard(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustForKeyboard(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        configureNavigationBar()
        configureViews()
        drawBackground()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutViews()
    }
    
    private func configureViews() {
        nameInput.delegate = self
        emailInput.delegate = self
        passwordInput.delegate = self
        repeatPasswordInput.delegate = self
        registerButton.addTarget(self,
                              action: #selector(didTapRegisterButton),
                              for: .touchUpInside)
        loginButton.addTarget(self,
                              action: #selector(didTapLoginButton),
                              for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(nameInput)
        scrollView.addSubview(emailInput)
        scrollView.addSubview(passwordInput)
        scrollView.addSubview(repeatPasswordInput)
        scrollView.addSubview(registerButton)
        scrollView.addSubview(loginButton)
    }
    
    // MARK: Actions
    
    @objc private func didTapRegisterButton() {
        ProgressHUD.animationType = .circleRotateChase
        ProgressHUD.show()
        
        presenter.registerUser(
            with: emailInput.getValue(),
            name: nameInput.getValue(),
            password: passwordInput.getValue(),
            confirm: repeatPasswordInput.getValue())
    }
    
    @objc private func didTapLoginButton() {
        delegate?.didTapLogin()
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    // MARK: Common
    
    private func layoutViews() {
        
        let inputSize: CGFloat = 78
        
        scrollView.frame = view.bounds
        nameInput.frame = CGRect(
            x: 16,
            y: 180,
            width: view.width - 32,
            height: inputSize)
        emailInput.frame = CGRect(x: 16,
                                     y: nameInput.bottom + 16,
                                     width: view.width - 32,
                                     height: inputSize)
        passwordInput.frame = CGRect(x: 16,
                                     y: emailInput.bottom + 16,
                                     width: view.width - 32,
                                     height: inputSize)
        repeatPasswordInput.frame = CGRect(x: 16,
                                     y: passwordInput.bottom + 16,
                                     width: view.width - 32,
                                     height: inputSize)
        
        registerButton.frame = CGRect(
            x: 16,
            y: repeatPasswordInput.bottom + 16,
            width: 100,
            height: 55)
        loginButton.frame = CGRect(
            x: registerButton.right + 16,
            y: repeatPasswordInput.bottom + 16,
            width: 100,
            height: 55)
        
        scrollView.contentSize = CGSize(width: view.width, height: loginButton.bottom + 32)
    }
    
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    private func drawBackground() {
        let path = UIBezierPath()
        
        let fillColor = Constants.primaryColor
        
        let figureHeight: CGFloat = 120
        let edgeX: CGFloat = UIScreen.main.bounds.width
        let edgeY: CGFloat = UIScreen.main.bounds.height
        
        path.move(to: CGPoint(x: 0, y: edgeY))
        path.addLine(to: CGPoint(x: 0, y: edgeY - 40))
        path.addCurve(
            to: CGPoint(x: edgeX, y: edgeY - figureHeight),
            controlPoint1: CGPoint(x: edgeX * 2 / 3, y: edgeY),
            controlPoint2: CGPoint(x: edgeX * 5 / 6, y: edgeY - figureHeight * 5 / 5))
        path.addLine(to: CGPoint(x: edgeX, y: edgeY))
        path.close()
    
        path.move(to: CGPoint(x: edgeX, y: 0))
        path.addLine(to: CGPoint(x: edgeX, y: 60))
        path.addCurve(
            to: CGPoint(x: 0, y: figureHeight + 20),
            controlPoint1: CGPoint(x: figureHeight * 6 / 3, y: figureHeight * 2 / 10),
            controlPoint2: CGPoint(x: figureHeight, y: (figureHeight + 20) * 3 / 2))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        
        scrollView.layer.addSublayer(shapeLayer)
    }
}

// MARK: UITextFieldDelegate
extension RegisterViewController: InputViewDelegate {
    
    func inputViewShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func inputViewTextFieldDidReturn(_ textField: UITextField, with label: String?, tag: String) {
        textField.resignFirstResponder()
        if label == "Name" {
            emailInput.makeFirstResponder()
        } else if label == "Email" {
            passwordInput.makeFirstResponder()
        } else if label == "Password" {
            repeatPasswordInput.makeFirstResponder()
        } else {
            didTapRegisterButton()
        }
    }
}


// MARK: RegisterPresenterDelegate
extension RegisterViewController: RegisterPresenterDelegate {
    
    func presentAlert(with title: String, message: String) {
        DispatchQueue.main.async {
            ProgressHUD.show(icon: .failed)
            let alert = ComponentFactory.shared.produceUIAlert(
                with: title,
                message: message)
            
            self.present(alert, animated: true)
        }
    }
    
    func onRegisterSuccess() {
        ProgressHUD.show(icon: .succeed)
        delegate?.didRegister()
    }

}

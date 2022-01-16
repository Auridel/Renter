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
    
    private let nameInput = InputView(
        "Name",
        returnKey: .next)
    
    private let emailInput = InputView(
        "Email",
        returnKey: .next)
    
    private let passwordInput = InputView(
        "Password",
        returnKey: .done)
    
    private let repeatPasswordInput = InputView(
        "Repeat Password",
        returnKey: .next)
    
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
        
        view.addSubview(nameInput)
        view.addSubview(emailInput)
        view.addSubview(passwordInput)
        view.addSubview(repeatPasswordInput)
        view.addSubview(registerButton)
        view.addSubview(loginButton)
    }
    
    // MARK: Actions
    
    @objc private func didTapRegisterButton() {
        // TODO: try to auth, notify coordinator
    }
    
    @objc private func didTapLoginButton() {
        delegate?.didTapLogin()
    }
    
    // MARK: Common
    
    private func layoutViews() {
        
        let inputSize: CGFloat = 78
        
        nameInput.frame = CGRect(
            x: 16,
            y: (view.height - (78 * 4)) / 2 - 16,
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
        
        view.layer.addSublayer(shapeLayer)
    }
}

// MARK: UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO: focus logic
        
        return true
    }
}


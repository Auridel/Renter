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
    
    private var presenter = LoginPresenter()
    
    private let scrollView = UIScrollView()
    
    private let loginInput = InputView(
        "Email",
        returnKey: .next)
    
    private let passwordInput = InputView(
        "Password",
        returnKey: .done,
        isSecure: true
    )
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("LogIn", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.primaryColor
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(Constants.primaryColor, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login"
        view.backgroundColor = .systemBackground
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        presenter.delegate = self
        configureNavigationBar()
        configureViews()
        drawBackground()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutViews()
    }
    
    private func configureViews() {
        loginInput.delegate = self
        passwordInput.delegate = self
        loginButton.addTarget(self,
                              action: #selector(didTapLoginButton),
                              for: .touchUpInside)
        registerButton.addTarget(self,
                                 action: #selector(didTapRegisterButton),
                                 for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(loginInput)
        scrollView.addSubview(passwordInput)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(registerButton)
    }
    
    // MARK: Actions
    
    @objc private func didTapLoginButton() {
        // TODO: try to auth, notify coordinator
        guard let email = loginInput.getValue(),
              let password = passwordInput.getValue()
        else {
            return
        }
        presenter.proceedToLogin(with: email, password: password)
    }
    
    @objc private func didTapRegisterButton() {
        delegate?.didTapRegister()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if scrollView.height == view.height {
                scrollView.frame.size.height -= keyboardSize.height
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if scrollView.height != view.height {
            scrollView.frame.size.height = view.height
        }
    }
    
    // MARK: Common
    
    private func layoutViews() {
        
        let inputSize: CGFloat = 78
        
        scrollView.frame = view.bounds
        loginInput.frame = CGRect(
            x: 16,
            y: 100,
            width: view.width - 32,
            height: inputSize)
        passwordInput.frame = CGRect(x: 16,
                                     y: loginInput.bottom + 16,
                                     width: view.width - 32,
                                     height: inputSize)
        loginButton.frame = CGRect(
            x: 16,
            y: passwordInput.bottom + 16,
            width: 100,
            height: 55)
        registerButton.frame = CGRect(
            x: loginButton.right + 16,
            y: passwordInput.bottom + 16,
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
        
        let figureHeight: CGFloat = 200
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
            to: CGPoint(x: 0, y: figureHeight),
            controlPoint1: CGPoint(x: figureHeight * 6 / 4, y: figureHeight / 10),
            controlPoint2: CGPoint(x: figureHeight, y: figureHeight * 4 / 3))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        
        view.layer.addSublayer(shapeLayer)
    }
}

// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO: focus logic
        
        return true
    }
}

// MARK: LoginPresenterDelegate
extension LoginViewController: LoginPresenterDelegate {
    func presentAlert(with error: String) {
        print(error)
    }
    
    func onLoginSuccess() {
        delegate?.didLogin()
    }
    
    
}

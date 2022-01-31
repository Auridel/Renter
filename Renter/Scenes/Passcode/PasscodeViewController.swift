//
//  PasscodeViewController.swift
//  Renter
//
//  Created by Oleg Efimov on 30.01.2022.
//

import UIKit
import LocalAuthentication
import ProgressHUD

protocol PasscodeViewControllerDelegate: AnyObject {
    func passcodeViewControllerDidLogin()
    func passcodeViewControllerDidTapBack()
}

class PasscodeViewController: UIViewController {
    
    weak var delegate: PasscodeViewControllerDelegate?
    
    private var passcode = [Int]()
    
    private var titleText: String?
    
    private var allowFaceId: Bool
    
    private let pinsView = GroupedPinView()
    
    internal var presenter: PasscodePresenterProtocol?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 50,
                                 height: 50)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
        collectionView.register(PasscodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: PasscodeCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: Object Lifecycle
    
    init(title: String? = "Enter Passcode", allowFaceId: Bool = true) {
        titleText = title
        self.allowFaceId = allowFaceId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Back To Login",
            style: .done,
            target: self,
            action: #selector(didTapBackButton))
        
        configureViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleLabel.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: 40)
        pinsView.frame = CGRect(
            x: 0,
            y: titleLabel.bottom + 30,
            width: view.width,
            height: 50)
        collectionView.frame = CGRect(
            x: view.width / 2 - (70 * 3) / 2,
            y: pinsView.bottom + 50,
            width: 70 * 3,
            height: view.height - view.safeAreaInsets.bottom - pinsView.bottom - 24)
    }
    
    // MARK: Actions
    
    @objc private func didTapBackButton() {
        delegate?.passcodeViewControllerDidTapBack()
    }
    
    // MARK: Common
    
    private func configureViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        titleLabel.text = titleText
        
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(pinsView)
    }
    
    private func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authorize to log in"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: reason) { [weak self] isSuccess, error in
                guard isSuccess, error == nil else {
                    return
                }
                self?.presenter?.didAuthorizeWithBiometric()
            }
        }
    }
    
    private func didPressNumber(_ number: Int) {
        if passcode.count < 4 {
            passcode.append(number)
            pinsView.updatePins(selectedCount: passcode.count)
            if passcode.count == 4 {
                presenter?.didEnterPasscode(passcode)
            }
        }
    }
    
    private func didPressDelete() {
        if !passcode.isEmpty {
            passcode.removeLast()
            pinsView.updatePins(selectedCount: passcode.count)
        }
    }
}


// MARK: CollectionView
extension PasscodeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PasscodeCollectionViewCell.identifier,
            for: indexPath) as? PasscodeCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        if indexPath.row < 9 {
            cell.configure(
                with: PasscodeCollectionViewCellViewModel(
                    label: "\(indexPath.row + 1)",
                    image: nil,
                    onPress: { [weak self] in
                        self?.didPressNumber(indexPath.row + 1)
                    }))
        } else if indexPath.row == 9 {
            cell.configure(
                with: PasscodeCollectionViewCellViewModel(
                    label: nil,
                    image: UIImage(
                        systemName: "delete.left",
                        withConfiguration: UIImage.SymbolConfiguration(
                            font: .systemFont(ofSize: 24))),
                    onPress: { [weak self] in
                        self?.didPressDelete()
                    }))
        } else if indexPath.row == 10 {
            cell.configure(
                with: PasscodeCollectionViewCellViewModel(
                    label: "\(0)",
                    image: nil,
                    onPress: { [weak self] in
                        self?.didPressNumber(0)
                    }))
        } else if indexPath.row == 11 {
            if allowFaceId {
                cell.configure(
                    with: PasscodeCollectionViewCellViewModel(
                        label: nil,
                        image: UIImage(
                            systemName: "face.dashed",
                            withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 24))),
                        onPress: { [weak self] in
                            self?.authenticateUser()
                        }))
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.row == 11 {
            authenticateUser()
        } else if indexPath.row < 10 {
            
        }
    }
    
}

// MARK: PasscodePresenterDelegate
extension PasscodeViewController: PasscodePresenterDelegate {
    
    func passcodePresenterKeychainFailure() {
        delegate?.passcodeViewControllerDidTapBack()
    }
    
    
    func passcodePresenterDidLogin() {
        ProgressHUD.show(icon: .succeed)
        delegate?.passcodeViewControllerDidLogin()
    }
    
    func passcodePresenterPresentAlert(with message: String) {
        DispatchQueue.main.async {
            let alert = ComponentFactory.shared.produceUIAlert(
                with: "Error",
                message: message)
            
            self.present(alert, animated: true)
        }
    }
    
    func passcodePresenterSetTitle(_ title: String) {
        DispatchQueue.main.async {
            self.titleText = title
            self.titleLabel.text = title
        }
    }
    
    func passcodePresenterClearPasscode() {
        passcode = []
        pinsView.updatePins(selectedCount: 0)
    }
    
}

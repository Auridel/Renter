//
//  PasscodeViewController.swift
//  Renter
//
//  Created by Oleg Efimov on 30.01.2022.
//

import UIKit
import LocalAuthentication

class PasscodeViewController: UIViewController {
    
    private var passcode = [Int]()
    
    private let pinsView = GroupedPinView()
    
    private var presenter: PasscodePresenter?
    
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
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        presenter = PasscodePresenter()
        presenter?.delegate = self
        
        configureViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pinsView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top + 24,
            width: view.width,
            height: 50)
        collectionView.frame = CGRect(
            x: view.width / 2 - (70 * 3) / 2,
            y: pinsView.bottom + 50,
            width: 70 * 3,
            height: view.height - view.safeAreaInsets.bottom - pinsView.bottom - 24)
    }
    
    // MARK: Common
    private func configureViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
                    //TODO: failed
                    return
                }
                // TODO: success
            }
        }
    }
    
    private func didPressNumber(_ number: Int) {
        if passcode.count < 4 {
            passcode.append(number)
            pinsView.updatePins(selectedCount: passcode.count)
            if passcode.count == 4 {
                
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
    
    func presentAlert(with message: String) {
        
    }
    
    
}

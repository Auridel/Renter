//
//  PasscodeViewController.swift
//  Renter
//
//  Created by Oleg Efimov on 30.01.2022.
//

import UIKit

class PasscodeViewController: UIViewController {
    
    private var passcode = [Int]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
        
        return collectionView
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: Common
    
}

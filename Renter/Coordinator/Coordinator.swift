//
//  Coordinator.swift
//  Renter
//
//  Created by Oleg Efimov on 15.01.2022.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    var children: [Coordinator]? { get set }
    
    init(navigationController: UINavigationController)
    
    func start()
}

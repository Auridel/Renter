//
//  AccountConfigurator.swift
//  Renter
//
//  Created by Oleg Efimov on 16.01.2022.
//

import Foundation

class AccountConfigurator {
    
    public static let shared = AccountConfigurator()
    
    private init(){}
    
    public func configure(with viewController: AccountViewController) {
        let interactor = AccountInteractor()
        let presenter = AccountPresenter()
        let router = AccountRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}

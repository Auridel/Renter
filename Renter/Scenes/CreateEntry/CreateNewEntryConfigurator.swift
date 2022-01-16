//
//  CreateNewEntryConfigurator.swift
//  Renter
//
//  Created by Oleg Efimov on 16.01.2022.
//

import Foundation

class CreateNewEntryConfigurator {
    
    public static let shared = CreateNewEntryConfigurator()
    
    private init(){}
    
    public func configure(with viewController: CreateNewEntryViewController) {
        let interactor = CreateNewEntryInteractor()
        let presenter = CreateNewEntryPresenter()
        let router = CreateNewEntryRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}

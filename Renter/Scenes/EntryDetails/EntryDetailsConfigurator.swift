//
//  EntryDetailsConfigurator.swift
//  Renter
//
//  Created by Oleg Efimov on 17.01.2022.
//

import Foundation

class EntryDetailConfigurator {
    
    public static let shared = EntryDetailConfigurator()
    
    private init(){}
    
    public func configure(with viewController: EntryDetailsViewController) {
        let interactor = EntryDetailsInteractor()
        let presenter = EntryDetailsPresenter()
        let router = EntryDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}

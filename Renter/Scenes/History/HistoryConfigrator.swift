//
//  HistoryConfigrator.swift
//  Renter
//
//  Created by Oleg Efimov on 16.01.2022.
//

import Foundation

class HistoryConfigurator {
    
    public static let shared = HistoryConfigurator()
    
    private init(){}
    
    public func configure(with viewController: HistoryViewController) {
        let interactor = HistoryInteractor()
        let presenter = HistoryPresenter()
        let router = HistoryRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}

//
//  EntryDetailsViewController.swift
//  Renter
//
//  Created by Oleg Efimov on 17.01.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EntryDetailsDisplayLogic: AnyObject {
    func displayEntry(viewModel: EntryDetails.GetEntry.ViewModel)
//    func displaySomethingElse(viewModel: EntryDetails.SomethingElse.ViewModel)
}

class EntryDetailsViewController: UIViewController, EntryDetailsDisplayLogic {
    
    var interactor: EntryDetailsBusinessLogic?
    
    var router: (NSObjectProtocol & EntryDetailsRoutingLogic & EntryDetailsDataPassing)?


    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        EntryDetailConfigurator.shared.configure(with: self)
        
        passEntryRequest()
    }
    
    //MARK: - receive events from UI

    
    // MARK: - request data from EntryDetailsInteractor

    func passEntryRequest() {
        let request = EntryDetails.GetEntry.Request()
        interactor?.getEntry(request: request)
    }
//
//    func doSomethingElse() {
//        let request = EntryDetails.SomethingElse.Request()
//        interactor?.doSomethingElse(request: request)
//    }

    // MARK: - display view model from EntryDetailsPresenter

    func displayEntry(viewModel: EntryDetails.GetEntry.ViewModel) {
        //nameTextField.text = viewModel.name
    }
//
//    func displaySomethingElse(viewModel: EntryDetails.SomethingElse.ViewModel) {
//        // do sometingElse with viewModel
//    }
}

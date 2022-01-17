//
//  CreateNewEntryInteractor.swift
//  Renter
//
//  Created by Oleg Efimov on 16.01.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CreateNewEntryBusinessLogic {
    func getCurrentPlanData(request: CreateNewEntry.GetMeters.Request)
    func createNewEntry(request: CreateNewEntry.SaveNewEntry.Request)
}

protocol CreateNewEntryDataStore {
}

class CreateNewEntryInteractor: CreateNewEntryBusinessLogic, CreateNewEntryDataStore {
    var presenter: CreateNewEntryPresentationLogic?
    var worker: CreateNewEntryWorker?

    // MARK: Do something (and send response to CreateNewEntryPresenter)

    func getCurrentPlanData(request: CreateNewEntry.GetMeters.Request) {
        worker = CreateNewEntryWorker()
        worker?.doSomeWork()

        let response = CreateNewEntry.GetMeters.Response()
        presenter?.presentCurrentPlan(response: response)
    }

    func createNewEntry(request: CreateNewEntry.SaveNewEntry.Request) {
//        worker = CreateNewEntryWorker()
//        worker?.doSomeOtherWork()
//
//        let response = CreateNewEntry.SaveNewEntry.Response()
//        presenter?.presentTransactionStatus(response: response)
    }
}
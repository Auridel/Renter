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
    var actualPlan: UserPlan? { get set }
}

class CreateNewEntryInteractor: CreateNewEntryBusinessLogic, CreateNewEntryDataStore {
    
    var presenter: CreateNewEntryPresentationLogic?
    
    var worker: CreateNewEntryWorker?
    
    var actualPlan: UserPlan?

    // MARK: Do something (and send response to CreateNewEntryPresenter)

    func getCurrentPlanData(request: CreateNewEntry.GetMeters.Request) {
        guard let actualPlan = actualPlan else {
            return
        }
        let response = CreateNewEntry.GetMeters.Response(plan: actualPlan)
        presenter?.presentCurrentPlan(response: response)
    }

    func createNewEntry(request: CreateNewEntry.SaveNewEntry.Request) {
        worker = CreateNewEntryWorker()
        do {
            let converted = try worker?.convertStringToDouble(request)
            if let data = converted {
                ApiManager.shared.createNewEntry(with: data) { [weak self] isSuccess in
                    self?.presenter?.presentTransactionStatus(
                        response: CreateNewEntry.SaveNewEntry.Response(
                            isSuccess: isSuccess))
                    NotificationCenter.default.post(name: .entriesUpdated,
                                                    object: nil)
                    return
                }
            } else {
                presenter?.presentAlert(with: "Incorrect values!")
            }
        } catch {
            presenter?.presentAlert(with: "Values must be numbers!")
        }
    }
}

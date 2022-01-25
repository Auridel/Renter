//
//  HistoryInteractor.swift
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

protocol HistoryBusinessLogic {
    func getHistory(request: History.GetHistoryData.Request)
    func getFiltredHistory(request: History.FilterData.Request)
}

protocol HistoryDataStore {
    var historyEntries: [HistoryEntry] { get set }
}

class HistoryInteractor: HistoryBusinessLogic, HistoryDataStore {
    
    var presenter: HistoryPresentationLogic?
    
    var worker: HistoryWorkerProtocol?
    
    var historyEntries = [HistoryEntry]()

    init(worker: HistoryWorkerProtocol) {
        self.worker = worker
    }

    func getHistory(request: History.GetHistoryData.Request) {
        worker?.fetchHistoryData(completion: { [weak self] entries in
            guard let entries = entries else {
                return
            }
            self?.historyEntries = entries
            self?.presenter?.presentHistory(
                response: History.GetHistoryData.Response(entries: entries))
        })
    }

    func getFiltredHistory(request: History.FilterData.Request) {
//        worker = HistoryWorker()
//        worker?.doSomeOtherWork()
//
//        let response = History.FilterData.Response()
//        presenter?.presentFilteredHistory(response: response)
    }
}

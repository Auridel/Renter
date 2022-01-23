//
//  HistoryPresenter.swift
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

protocol HistoryPresentationLogic {
    func presentHistory(response: History.GetHistoryData.Response)
    func presentFilteredHistory(response: History.FilterData.Response)
}

class HistoryPresenter: HistoryPresentationLogic {
    weak var viewController: HistoryDisplayLogic?

    // MARK: Parse and calc respnse from HistoryInteractor and send simple view model to HistoryViewController to be displayed

    func presentHistory(response: History.GetHistoryData.Response) {
        
        //TODO: Compute total with worker
        let viewModel = History.GetHistoryData.ViewModel(
            rows: response.entries.compactMap({
                HistoryRowViewModel.init(
                    date: $0.date.formattedDate(),
                    price: "\(String(format: "%.2f", $0.price)) rub")
            }))
        viewController?.displayHistory(viewModel: viewModel)
    }

    func presentFilteredHistory(response: History.FilterData.Response) {
//        let viewModel = History.FilterData.ViewModel()
//        viewController?.displayFiltredHistory(viewModel: viewModel)
    }
}



//
//  EntryDetailsPresenter.swift
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

protocol EntryDetailsPresentationLogic {
    func presentEntry(response: EntryDetails.GetEntry.Response)
}

class EntryDetailsPresenter: EntryDetailsPresentationLogic {
    weak var viewController: EntryDetailsDisplayLogic?

    // MARK: Parse and calc respnse from EntryDetailsInteractor and send simple view model to EntryDetailsViewController to be displayed

    func presentEntry(response: EntryDetails.GetEntry.Response) {
        let meters = response.entry.meters
        let plan = response.entry.curPlan
        var sections = [EntrySectionViewModel]()
        sections.append(EntrySectionViewModel(
            title: "Current Plan",
            rows: [
                EntryRowViewModel(title: "Cold Water", value: "\(plan.coldPlan)"),
                EntryRowViewModel(title: "Hot Water", value: "\(plan.hotPlan)"),
                EntryRowViewModel(title: "Day Electricity", value: "\(plan.dayPlan)"),
                EntryRowViewModel(title: "Night Electricity", value: "\(plan.nightPlan)"),
            ]))
        sections.append(EntrySectionViewModel(
            title: "Meters Data",
            rows: [
                EntryRowViewModel(title: "Cold Water", value: "\(meters.cold)"),
                EntryRowViewModel(title: "Hot Water", value: "\(meters.hot)"),
                EntryRowViewModel(title: "Day Electricity", value: "\(meters.day)"),
                EntryRowViewModel(title: "Night Electricity", value: "\(meters.night)"),
            ]))
        sections.append(EntrySectionViewModel(
            title: "",
            rows: [
                EntryRowViewModel(title: response.entry.date.formattedDate(), value: ""),
                EntryRowViewModel(
                    title: "Price",
                    value: String(format: "%.2f", response.entry.price))
            ]))
        let viewModel = EntryDetails.GetEntry.ViewModel(sections: sections)
        viewController?.displayEntry(viewModel: viewModel)
    }
//
//    func presentSomethingElse(response: EntryDetails.SomethingElse.Response) {
//        let viewModel = EntryDetails.SomethingElse.ViewModel()
//        viewController?.displaySomethingElse(viewModel: viewModel)
//    }
}

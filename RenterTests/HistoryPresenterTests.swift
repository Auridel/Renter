//
//  HistoryPresenterTests.swift
//  RenterTests
//
//  Created by Oleg Efimov on 25.01.2022.
//

import XCTest
@testable import Renter

class HistoryViewControllerSpy: HistoryDisplayLogic {
    
    var displayHistoryCalled = false
    
    var displayedRows = [HistoryRowViewModel]()
    
    func displayHistory(viewModel: History.GetHistoryData.ViewModel) {
        displayHistoryCalled = true
        displayedRows = viewModel.rows
    }
    
    func displayFilteredHistory(viewModel: History.FilterData.ViewModel) {
        
    }
    
    
}

class HistoryPresenterTests: XCTestCase {

    func testDisplayHistoryCalledByPresenter() {
        let vcSpy = HistoryViewControllerSpy()
        let sut = HistoryPresenter()
        sut.viewController = vcSpy
        
        sut.presentHistory(response: History.GetHistoryData.Response(entries: Seeds.HistoryResponseSeed.historyResponse.entries))
        
        XCTAssert(vcSpy.displayHistoryCalled, "should ask viewController to display entries")
    }
    
    func testPresentedEntriesShouldBeFormattedFoeDisplay() {
        let vcSpy = HistoryViewControllerSpy()
        let sut = HistoryPresenter()
        let dummyEntries = Seeds.HistoryResponseSeed.historyResponse.entries
        sut.viewController = vcSpy
        
        sut.presentHistory(response: History.GetHistoryData.Response(entries: dummyEntries))
        
        XCTAssertEqual(vcSpy.displayedRows.count, dummyEntries.count, "should ask viewController to display entries")
        for (row, model) in zip(vcSpy.displayedRows, dummyEntries) {
            XCTAssertEqual(row.price, "\(String(format: "%.2f", model.price)) rub", "strings should be formatted properly")
        }
    }

}

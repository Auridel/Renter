//
//  HistoryTests.swift
//  RenterTests
//
//  Created by Oleg Efimov on 25.01.2022.
//

import XCTest
@testable import Renter

class HistoryPresenterSpy: HistoryPresentationLogic {
    
    var presentHistoryCalled = false
    
    var presentFiltredHistoryCalled = false
    
    var entries: [HistoryEntry]?
    
    func presentHistory(response: History.GetHistoryData.Response) {
        presentHistoryCalled = true
        self.entries = response.entries
    }
    
    func presentFilteredHistory(response: History.FilterData.Response) {
        presentFiltredHistoryCalled = true
    }
    
}

class HistoryWorkerSpy: HistoryWorkerProtocol {
    
    var fetchHistoryDataCalled = false
    
    var entries: [HistoryEntry]
    
    init(entries: [HistoryEntry]) {
        self.entries = entries
    }
    
    func fetchHistoryData(completion: @escaping ([HistoryEntry]?) -> Void) {
        fetchHistoryDataCalled = true
        completion(self.entries)
    }
    
}

class HistoryInteractorTests: XCTestCase {
    
    override func setUp() {
        
    }
    
    override class func tearDown() {
        
    }
    
    func testGetHistoryCalledWorkerToFetch() {
        //given
        let historyWorkerSpy = HistoryWorkerSpy(entries: Seeds.HistoryResponseSeed.historyResponse.entries)
        let sut = HistoryInteractor(worker: historyWorkerSpy)
        sut.presenter = HistoryPresenterSpy()
        
        //when
        sut.getHistory(request: History.GetHistoryData.Request())
        
        //then
        XCTAssert(historyWorkerSpy.fetchHistoryDataCalled, "should ask worker to fetch data")
    }
    
    func testGetHistoryCalledPresenterToPresentEntries() {
        let historyWorkerSpy = HistoryWorkerSpy(entries: Seeds.HistoryResponseSeed.historyResponse.entries)
        let sut = HistoryInteractor(worker: historyWorkerSpy)
        let historyPresenterSpy = HistoryPresenterSpy()
        sut.presenter = historyPresenterSpy
        
        sut.getHistory(request: History.GetHistoryData.Request())
        
        XCTAssert(historyPresenterSpy.presentHistoryCalled, "should call presenter to present entries")
    }
}

//
//  HistoryViewControllerTests.swift
//  RenterTests
//
//  Created by Oleg Efimov on 25.01.2022.
//

import XCTest
@testable import Renter

class HistoryInteractorSpy: HistoryBusinessLogic {
    
    var getHistoryWasCalled = false
    
    func getHistory(request: History.GetHistoryData.Request) {
        getHistoryWasCalled = true
    }
    
    func getFiltredHistory(request: History.FilterData.Request) {
        
    }
    
    
}

class HistoryViewControllerTests: XCTestCase {

    var sut: HistoryViewController!
    
    var interactorSpy: HistoryInteractorSpy!
    
    override func setUp() {
        super.setUp()
        
        sut = HistoryViewController()
        interactorSpy = HistoryInteractorSpy()
        sut.interactor = interactorSpy
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
    }
    
    override func tearDown() {
        sut = nil
        interactorSpy = nil
    }

    func testShouldFetchEntriesWhenViewDidLoad() {
        sut.viewDidLoad()
        
        XCTAssert(interactorSpy.getHistoryWasCalled, "should call interactor to fetch entries when view is loaded")
    }
    
}

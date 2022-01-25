//
//  Seeds.swift
//  RenterTests
//
//  Created by Oleg Efimov on 25.01.2022.
//

import Foundation
@testable import Renter

struct Seeds {
    struct HistoryResponseSeed {
        static let historyResponse = HistoryResponse(entries: [
            HistoryEntry(
                curPlan: UserPlan(
                    coldPlan: 32.53,
                    hotPlan: 109.1,
                    dayPlan: 4.06,
                    nightPlan: 2.34),
                meters: MetersData(
                    cold: 229,
                    hot: 151,
                    day: 11222,
                    night: 1511),
                date: "2020-10-24T22:42:52.241Z",
                price: 1304.4899999999998,
                timestamp: 1603579372241),
            HistoryEntry(
                curPlan: UserPlan(
                    coldPlan: 32.53,
                    hotPlan: 109.1,
                    dayPlan: 4.06,
                    nightPlan: 2.34),
                meters: MetersData(
                    cold: 231,
                    hot: 154,
                    day: 11342,
                    night: 1541),
                date: "2020-11-24T22:42:52.241Z",
                price: 1504.4899999999998,
                timestamp: 1621659380397),
            HistoryEntry(
                curPlan: UserPlan(
                    coldPlan: 32.53,
                    hotPlan: 109.1,
                    dayPlan: 4.06,
                    nightPlan: 2.34),
                meters: MetersData(
                    cold: 233,
                    hot: 155,
                    day: 11522,
                    night: 1571),
                date: "2020-12-24T22:42:52.241Z",
                price: 1404.4899999999998,
                timestamp: 1624791892705)
        ])
    }
    
    struct HistoryRowsSeed {
        static let rows: [HistoryRowViewModel] = [
            HistoryRowViewModel(date: "2021-05-22T04:56:20.397Z", price: "1327"),
            HistoryRowViewModel(date: "021-06-27T11:04:52.705Z", price: "1195")
        ]
    }
}

//
//  HistoryResponse.swift
//  Renter
//
//  Created by Oleg Efimov on 16.01.2022.
//

import Foundation

struct HistoryResponse: Codable {
    let entries: [HistoryEntry]
}

struct HistoryEntry: Codable {
    let curPlan: UserPlan
    let meters: MetersData
    let date: String
    let price: Double
    let timestamp: Double
}

struct UserPlan: Codable {
    let coldPlan: Double
    let hotPlan: Double
    let dayPlan: Double
    let nightPlan: Double
}

struct MetersData: Codable {
    let cold: Double
    let hot: Double
    let day: Double
    let night: Double
}

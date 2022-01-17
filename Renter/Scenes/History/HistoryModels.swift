//
//  HistoryModels.swift
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

struct HistoryRowViewModel {
    let date: String
    let price: String
}

enum History {
    // MARK: Use cases

    enum GetHistoryData {
        struct Request {

        }

        struct Response {
            let entries: [HistoryEntry]
        }

        struct ViewModel {
            let rows: [HistoryRowViewModel]
        }
    }
    
    enum FilterData {
        struct Request {
            let startsAt: Date
            let endsAt: Date
        }

        struct Response {
            //models
        }

        struct ViewModel {
            let rows: [HistoryRowViewModel]
        }
    }
}

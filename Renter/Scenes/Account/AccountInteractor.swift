//
//  AccountInteractor.swift
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

protocol AccountBusinessLogic {
    func getUser(request: Account.ShowUser.Request)
    func updateUser(request: Account.SaveUser.Request)
    func presentSignOutAlert()
    func signOutUser()
}

protocol AccountDataStore {
}

class AccountInteractor: AccountBusinessLogic, AccountDataStore {
    var presenter: AccountPresentationLogic?
    var worker: AccountWorker?

    // MARK: Do something (and send response to AccountPresenter)

    func getUser(request: Account.ShowUser.Request) {
        guard let user = AuthManager.shared.getUser()
        else { return }
        presenter?.presentUser(response: Account.ShowUser.Response(user: user))
    }

    func updateUser(request: Account.SaveUser.Request) {
//        worker = AccountWorker()
//        worker?.doSomeOtherWork()
//
//        let response = Account.SaveUser.Response()
//        presenter?.presentUpdatedUsername(response: response)
    }
    
    func signOutUser() {
        AuthManager.shared.signOut()
    }
    
    func presentSignOutAlert() {
        presenter?.presentSignOutAlert()
    }
}

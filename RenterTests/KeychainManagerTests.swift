//
//  KeychainManagerTests.swift
//  RenterTests
//
//  Created by Oleg Efimov on 26.01.2022.
//

import XCTest
@testable import Renter

class KeychainManagerTests: XCTestCase {
    
    var sut: KeychainManager!
    
    var account: String!
    
    override func setUpWithError() throws {
        sut = KeychainManager()
        account = "test_account"
    }
    
    override func tearDownWithError() throws {
        try? sut.deletePassword(account: account)
        sut = nil
        account = nil
    }
    
    func testShouldSavePasswordToKeychain() throws {
        let password = "122345"
        let passwordData = password.data(using: .utf8)
        
        try sut.savePassword(password: passwordData as! Data, account: account)
        let retrievedPassword = try sut.readPassword(account: account)
        let decryptedPassword = String(data: retrievedPassword, encoding: .utf8) as! String
        
        XCTAssertEqual(retrievedPassword, passwordData, "Password in keychain must be equel with given password")
        XCTAssertEqual(decryptedPassword, password, "decrypted password should be equal with given password")
    }
    
    func testShouldUpdatePasswordInKeychain() throws {
        let firstPassword = "12345"
        let passwordToUpdate = "67890"
        
        let firstPassAsData = firstPassword.data(using: .utf8) as! Data
        let passToUpdateAsData = passwordToUpdate.data(using: .utf8) as! Data
        
        try sut.savePassword(password: firstPassAsData, account: account)
        try sut.updatePassword(password: passToUpdateAsData, account: account)
        let retrievedPasswordAsData = try sut.readPassword(account: account)
        let retrievedPasswordAsString = String(data: retrievedPasswordAsData, encoding: .utf8)
        
        XCTAssertEqual(retrievedPasswordAsData, passToUpdateAsData, "data from keychain should be equal yo given data")
        XCTAssertEqual(retrievedPasswordAsString, passwordToUpdate, "retrieved password string must be equal to given password string")
    }
    
    func testShoudNotDuplicatePasswords() throws {
        let firstPassword = "12345"
        let passwordToUpdate = "67890"
        
        let firstPassAsData = firstPassword.data(using: .utf8) as! Data
        let passToUpdateAsData = passwordToUpdate.data(using: .utf8) as! Data
        
        try sut.savePassword(password: firstPassAsData as! Data, account: account)
        
        do{
            try sut.savePassword(password: passToUpdateAsData, account: account)
        } catch let error as KeychainManager.KeychainError {
            XCTAssertEqual(error as! KeychainManager.KeychainError, KeychainManager.KeychainError.duplicateItem, "should throw error duplicatedItem")
        }
        
    }
}

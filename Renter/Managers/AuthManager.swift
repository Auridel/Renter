//
//  AuthManager.swift
//  Renter
//
//  Created by Oleg Efimov on 15.01.2022.
//

import Foundation

final class AuthManager {
    
    enum StorageKeys: String {
        case token, username, email, userId, expiredIn
    }
    
    enum PasscodeAuthResult {
        case invalidPasscode, failedToGetKeychainValues, failedToAuth, success
    }
    
    public static let shared = AuthManager()
    
    public var isAuthorized: Bool {
        guard accessToken != nil,
              let expiredIn = tokenExpirationTime
        else {
            return false
        }
        return expiredIn > Date()
    }
    
    public var isKeychainDataExists: Bool {
        guard let _ = try? keychainManager.readPassword(account: Keys.passcode.rawValue),
              let _ = try? keychainManager.readPassword(account: Keys.email.rawValue),
              let _ = try? keychainManager.readPassword(account: Keys.password.rawValue)
        else {
            return false
        }
        return true
    }
    
    private let keychainManager: KeychainManager
    
    private var tokenExpirationTime: Date? {
        UserDefaults.standard.value(forKey: "expiredIn") as? Date
    }
    
    private var accessToken: String? {
        UserDefaults.standard.string(forKey: "token")
    }
    
    private var userName: String? {
        UserDefaults.standard.string(forKey: "username")
    }
    
    private var userEmail: String? {
        UserDefaults.standard.string(forKey: "email")
    }
    
    private var userId: String? {
        UserDefaults.standard.string(forKey: "userId")
    }
    
    private init(){
        keychainManager = KeychainManager()
    }
    
    public func getUser() -> User? {
        guard let userId = userId,
              let userName = userName,
              let userEmail = userEmail
        else {
            return nil
        }
        return User(
            userId: userId,
            userName: userName,
            email: userEmail)
    }
    
    public func getAccessToken() -> String? {
        accessToken
    }
    
    public func updateUserName(with name: String) {
        UserDefaults.standard.setValue(name,
                                       forKey: StorageKeys.username.rawValue)
    }
    
    public func savePasscode(passcode: String) {
        guard let passcodeData = passcode.data(using: .utf8) else {
            return
        }
        try? keychainManager.savePassword(password: passcodeData,
                                          account: Keys.passcode.rawValue)
    }
    
    public func loginWithBiometric(completion: @escaping (PasscodeAuthResult) -> Void) {
        loginWithKeychainValues(completion: completion)
    }
    
    public func login(passcode: String, completion: @escaping (PasscodeAuthResult) -> Void) {
        guard let savedPasscodeData = try? keychainManager.readPassword(account: Keys.passcode.rawValue),
              let savedPasscodeString = String(data: savedPasscodeData,
                                               encoding: .utf8)
        else {
            completion(.failedToGetKeychainValues)
            return
        }
        if savedPasscodeString == passcode {
            loginWithKeychainValues(completion: completion)
        } else {
            completion(.invalidPasscode)
        }
    }
    
    //TODO: handle errors
    public func login(with email: String, password: String, completion: @escaping (Bool) -> Void) {
        ApiManager.shared.login(with: email, password: password) { [weak self] result in
            switch result {
            case .success(let response):
                self?.getDataFromToken(response.token, completion: completion)
                self?.saveUserDataToKeychain(email: email, password: password)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    public func register(with email: String, name: String, password: String, confirm: String, completion: @escaping (String) -> Void) {
        ApiManager.shared.register(with: email,
                                   name: name,
                                   password: password,
                                   confirm: confirm) { [weak self] result in
            switch result {
            case .success(let response):
                completion(response.message)
                self?.saveUserDataToKeychain(email: email, password: password)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    public func signOut(_ wipeKeychain: Bool = false) {
        if wipeKeychain {
            clearKeychainEntries()
        }
        let domain = Bundle.main.bundleIdentifier
        guard let domain = domain else {
            return
        }
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        //        print(UserDefaults.standard.dictionaryRepresentation().keys)
        NotificationCenter.default.post(
            name: .tokenExpired,
            object: nil)
    }
    
    // MARK: Private
    
    private func loginWithKeychainValues(completion: @escaping (PasscodeAuthResult) -> Void) {
        guard let userData = getUserDataFromKeychain()
        else {
            completion(.failedToGetKeychainValues)
            return
        }
        login(with: userData.email, password: userData.password) { isSuccess in
            if isSuccess {
                completion(.success)
            } else {
                completion(.failedToAuth)
            }
        }
    }
    
    private func getDataFromToken(_ token: String, completion: @escaping (Bool) -> Void) {
        do {
            let user = try JWTDecoder.shared.decode(token)
            let data = try JSONSerialization.data(
                withJSONObject: user,
                options: .fragmentsAllowed)
            let decodedUser = try JSONDecoder().decode(User.self,
                                                       from: data)
            
            saveUserData(user: decodedUser, token: token)
        } catch let error {
            print(error)
            completion(false)
            return
        }
        completion(true)
    }
    
    private func saveUserData(userId: String, username: String, email: String, token: String) {
        UserDefaults.standard.setValuesForKeys([
            StorageKeys.userId.rawValue: userId,
            StorageKeys.username.rawValue: username,
            StorageKeys.email.rawValue: email,
            StorageKeys.token.rawValue: token,
            StorageKeys.expiredIn.rawValue: Date.now.addingTimeInterval(60 * 60)
        ])
    }
    
    private func saveUserData(user: User, token: String) {
        UserDefaults.standard.setValuesForKeys([
            StorageKeys.userId.rawValue: user.userId,
            StorageKeys.username.rawValue: user.userName,
            StorageKeys.email.rawValue: user.email,
            StorageKeys.token.rawValue: token,
            StorageKeys.expiredIn.rawValue: Date.now.addingTimeInterval(60 * 60)
        ])
    }
    
    private func clearKeychainEntries() {
        try? keychainManager.deletePassword(account: Keys.passcode.rawValue)
        try? keychainManager.deletePassword(account: Keys.email.rawValue)
        try? keychainManager.deletePassword(account: Keys.password.rawValue)
    }
    
    private func saveUserDataToKeychain(email: String, password: String) {
        guard let emailData = email.data(using: .utf8),
              let passwordData = password.data(using: .utf8)
        else {
            print("Failed to save data to keychain")
            return
        }
        
        try? keychainManager.savePassword(password: emailData,
                                          account: Keys.email.rawValue)
        try? keychainManager.savePassword(password: passwordData,
                                          account: Keys.password.rawValue)
    }
    
    private func getUserDataFromKeychain() -> KeychainData? {
        do {
            let emailData = try keychainManager.readPassword(
                account: Keys.email.rawValue)
            let passwordData = try keychainManager.readPassword(
                account: Keys.password.rawValue)
            guard let email = String(data: emailData,
                                     encoding: .utf8),
                  let password = String(data: passwordData,
                                        encoding: .utf8)
            else { return nil }
            
            return KeychainData(email: email,
                                password: password)
        } catch let error {
            print(error)
            return nil
        }
    }
}

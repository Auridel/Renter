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
    
    public static let shared = AuthManager()
    
    public var isAuthorized: Bool {
        guard accessToken != nil,
              let expiredIn = tokenExpirationTime
        else {
            return false
        }
        return expiredIn > Date()
    }
    
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
    
    private init(){}
    
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
    
    //TODO: handle errors
    public func login(with email: String, password: String, completion: @escaping (Bool) -> Void) {
        ApiManager.shared.login(with: email, password: password) { [weak self] result in
            switch result {
            case .success(let response):
                self?.getDataFromToken(response.token, completion: completion)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    public func register(with email: String, name: String, password: String, confirm: String, completion: @escaping (Bool) -> Void) {
        ApiManager.shared.register(with: email,
                                   name: name,
                                   password: password,
                                   confirm: confirm) { [weak self] result in
            switch result {
            case .success(let response):
                self?.getDataFromToken(response.token, completion: completion)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    public func signOut() {
        let domain = Bundle.main.bundleIdentifier
        guard let domain = domain else {
            return
        }
        UserDefaults.standard.removePersistentDomain(forName: domain)
        NotificationCenter.default.post(
            name: .tokenExpired,
            object: nil)
    }
    
    // MARK: Private
    
    private func getDataFromToken(_ token: String, completion: @escaping (Bool) -> Void) {
        do {
            let user = try JWTDecoder.shared.decode(token)
            let data = try JSONSerialization.data(
                withJSONObject: user,
                options: .fragmentsAllowed)
            let decodedUser = try JSONDecoder().decode(User.self,
                                                       from: data)
            
            
            print(decodedUser)
            
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
}

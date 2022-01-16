//
//  AuthManager.swift
//  Renter
//
//  Created by Oleg Efimov on 15.01.2022.
//

import Foundation

final class AuthManager {
    
    enum StorageKeys: String {
        case token, username, email, userId
    }
    
    public static let shared = AuthManager()
    
    private var tokenExpirationTime: Date?
    
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
    
    //TODO: handle errors
    public func login(with email: String, password: String, completion: @escaping (Bool) -> Void) {
        ApiManager.shared.login(with: email, password: password) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let user = try JWTDecoder.shared.decode(response.token)
                    let data = try JSONSerialization.data(
                        withJSONObject: user,
                        options: .fragmentsAllowed)
                    let decodedUser = try JSONDecoder().decode(User.self,
                                                               from: data)
                    
                    
                    print(decodedUser)
                    
                    self?.saveUserData(user: decodedUser, token: response.token)
                } catch let error {
                    print(error)
                    completion(false)
                    return
                }
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    private func saveUserData(userId: String, username: String, email: String, token: String) {
        UserDefaults.standard.setValuesForKeys([
            StorageKeys.userId.rawValue: userId,
            StorageKeys.username.rawValue: username,
            StorageKeys.email.rawValue: email,
            StorageKeys.token.rawValue: token
        ])
        tokenExpirationTime = Date.now.addingTimeInterval(60 * 60)
    }
    
    private func saveUserData(user: User, token: String) {
        UserDefaults.standard.setValuesForKeys([
            StorageKeys.userId.rawValue: user.userId,
            StorageKeys.username.rawValue: user.userName,
            StorageKeys.email.rawValue: user.email,
            StorageKeys.token.rawValue: token
        ])
        tokenExpirationTime = Date.now.addingTimeInterval(60 * 60)
    }
}

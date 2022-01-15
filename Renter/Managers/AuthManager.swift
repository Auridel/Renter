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
    
    private func saveUserData(userId: String, username: String, email: String, token: String) {
        UserDefaults.standard.setValuesForKeys([
            StorageKeys.userId.rawValue: userId,
            StorageKeys.username.rawValue: username,
            StorageKeys.email.rawValue: email,
            StorageKeys.token.rawValue: token
        ])
        tokenExpirationTime = Date.now.addingTimeInterval(60 * 60)
    }
}

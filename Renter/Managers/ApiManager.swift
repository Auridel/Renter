//
//  ApiManager.swift
//  Renter
//
//  Created by Oleg Efimov on 15.01.2022.
//

import Foundation

final class ApiManager {
    
    enum HTTPMethod: String {
        case POST, GET
    }
    
    enum ApiError: Error {
        case failedToFetch, failedToGetData, unauthorized, failedToGetPostParameters, unknown
    }
    
    typealias TypedCompletion<T: Codable> = ((Result<T, Error>) -> Void)
    
    public static let shared = ApiManager()
    
    private let baseURLString = "https://renter-mern-deploy.herokuapp.com/api"
    
    private init(){}
    
    public func login(with email: String, password: String, completion: @escaping TypedCompletion<AuthResponse>) {
        performApiCall(
            to: "\(baseURLString)/auth/login",
            method: .POST,
            completion: completion,
            body: [
                "email": email,
                "password": password
            ])
    }
    
    public func getHistoryData(completion: @escaping TypedCompletion<HistoryResponse>) {
        performApiCall(
            to: "\(baseURLString)/account/get",
            method: .GET,
            completion: completion)
    }
    
    // MARK: Private Methods
    
    private func performApiCall<T: Codable>(to urlString: String, method: HTTPMethod, completion: @escaping TypedCompletion<T>, body: [String: String]? = nil) {
        createRequest(
            URL(string: urlString),
            method: method) { [weak self] baseRequest in
                guard let self = self else {
                    completion(.failure(ApiError.unknown))
                    return
                }
                var request = baseRequest
                switch method {
                case .POST:
                    guard let body = body else {
                        completion(.failure(ApiError.failedToGetPostParameters))
                        return
                    }
                    request.httpBody = try? JSONSerialization.data(
                        withJSONObject: body,
                        options: .fragmentsAllowed)
                case .GET:
                    break
                }
                self.getTypedResponse(request: request, completion: completion)
            }
    }
    
    private func createRequest(_ url: URL?, method: HTTPMethod, completion: (URLRequest) -> Void) {
        let token = AuthManager.shared.getAccessToken() ?? ""
        guard let url = url else {
            return
        }
        var request = URLRequest(url: url)
        request.setValue(
            "Bearer {\"token\":\"\(token)\"}",
            forHTTPHeaderField: "authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        completion(request)
    }
    
    private func getTypedResponse<T: Codable>(request: URLRequest, completion: @escaping TypedCompletion<T>) {
        URLSession.shared.dataTask(with: request) { data, res, error in
            guard let data = data,
                  error == nil
            else {
                print(String(describing: error))
                completion(.failure(ApiError.failedToFetch))
                return
            }
            
            do {
                //MARK: AUTH TEST
                //FIXME: REMOVE
                let testJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print(testJson)
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch let parseError {
                print(parseError)
                completion(.failure(ApiError.failedToGetData))
            }
        }.resume()
    }
    
    /// Test Get Api Call
    private func callApiToPrintResponse(_ urlString:String) {
        createRequest(URL(string: urlString),
                      method: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    print("Cannot get data")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print(result)
                } catch let error {
                    print(error)
                }
            }.resume()
        }
    }
}

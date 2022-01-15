//
//  JWTDecoder.swift
//  Renter
//
//  Created by Oleg Efimov on 15.01.2022.
//

import Foundation

enum JWTDecodeError: Error {
    case badToken, unknown
}

final class JWTDecoder {
    
    public static let shared = JWTDecoder()
    
    private init(){}
    
    public func decode(_ jwtToken: String) throws -> [String: Any] {
        let segments = jwtToken.components(separatedBy: ".")
        return try decodeJWTPart(segments[1])
    }
    
    private func base64Decode(_ base64: String) throws -> Data {
        let padded = base64.padding(
            toLength: ((base64.count + 3) / 4) * 4,
            withPad: "=",
            startingAt: 0)
        guard let jwtData = Data(base64Encoded: padded) else {
            throw JWTDecodeError.badToken
        }
        return jwtData
    }
    
    private func decodeJWTPart(_ value: String) throws -> [String: Any] {
        let data = try base64Decode(value)
        let json = try JSONSerialization.jsonObject(with: data,
                                                options: .fragmentsAllowed)
        guard let jwtPayload = json as? [String: Any] else {
            throw JWTDecodeError.unknown
        }
        return jwtPayload
    }
}

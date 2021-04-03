//
//  PostSessionResponse.swift
//  iOS-OnTheMap
//
//  Created by Anupam Beri on 29/03/2021.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct PostSessionResponse: Codable {
    let account: Account
    let session: Session
}

struct PostSessionErrorResponse: Codable {
    let status: Int
    let error: String
}

extension PostSessionErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}

//
//  File.swift
//  iOS-OnTheMap
//
//  Created by Anupam Beri on 29/03/2021.
//

import Foundation

struct UdacityCredentials: Codable {
    let username: String
    let password: String
}

struct PostSessionRequest: Codable {
    let udacity: UdacityCredentials
}

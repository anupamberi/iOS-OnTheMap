//
//  PostStudentLocationResponse.swift
//  iOS-OnTheMap
//
//  Created by Anupam Beri on 02/04/2021.
//

import Foundation

struct PostStudentLocationResponse: Codable {
    let createdAt: String
    let objectId: String
}

struct UpdateStudentLocationResponse: Codable {
    let updatedAt: String
}

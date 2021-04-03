//
//  StudentInformation.swift
//  iOS-OnTheMap
//
//  Created by Anupam Beri on 29/03/2021.
//

import Foundation

struct StudentInformation: Codable, Equatable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectId: String?
    let createdAt: String?
    let updatedAt: String?
}

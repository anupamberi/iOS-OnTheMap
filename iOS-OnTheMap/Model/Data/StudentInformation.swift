//
//  StudentInformation.swift
//  iOS-OnTheMap
//
//  Created by Anupam Beri on 29/03/2021.
//

import Foundation

struct StudentInformation: Codable, Equatable {
    var firstName: String
    var lastName: String
    var longitude: Double
    var latitude: Double
    var mapString: String
    var mediaURL: String
    var uniqueKey: String
    var objectId: String?
    var createdAt: String?
    var updatedAt: String?
}

extension StudentInformation {
    
    init() {
        self.firstName = ""
        self.lastName = ""
        self.longitude = 0.0
        self.latitude = 0.0
        self.mediaURL = ""
        self.mapString = ""
        self.uniqueKey = ""
        self.objectId = nil
        self.createdAt = nil
        self.updatedAt = nil
    }
    
    init(firstName: String, lastName: String, longitude: Double, latitude: Double, mapString: String, mediaURL: String, uniqueKey: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.longitude = longitude
        self.latitude = latitude
        self.mediaURL = mediaURL
        self.mapString = mapString
        self.uniqueKey = uniqueKey
        self.objectId = nil
        self.createdAt = nil
        self.updatedAt = nil
    }
}

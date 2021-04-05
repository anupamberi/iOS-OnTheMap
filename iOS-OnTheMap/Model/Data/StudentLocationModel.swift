//
//  StudentLocationModel.swift
//  iOS-OnTheMap
//
//  Created by Anupam Beri on 03/04/2021.
//

import Foundation

class StudentLocationModel {
    
    // MARK: A list of recent student locations obtained from the backend
    static var recentStudentLocations = [StudentInformation]()
    // MARK: If the user has already posted a location, this variable holds the information. If no location posted, then the value is nil
    static var lastLocationInformation: StudentInformation?
}

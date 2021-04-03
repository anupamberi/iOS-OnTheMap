//
//  OnTheMapClientTest.swift
//  iOS-OnTheMapTests
//
//  Created by Anupam Beri on 02/04/2021.
//

import XCTest

class OnTheMapClientTest: XCTestCase {

    func testGETRecentStudentLocations() throws {
        let expectation = XCTestExpectation(description: "Get recent student locations")
        
        var obtainedStudentLocations = [StudentInformation]()
        
        OnTheMapClient.getRecentStudentLocations(completion: { (studentLocations, error) in
            obtainedStudentLocations = studentLocations
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10.0)
        // Check if we have received the correct number of student locations
        XCTAssertEqual(obtainedStudentLocations.count, 100)
    }
    
    func testCreateSessionId() throws {
        let expectation = XCTestExpectation(description: "Authenticate a student and get unique id & session id")
        
        var sessionId: String = ""
        var uniqueKey: String = ""
        
        OnTheMapClient.createSessionId(username: "anupamberi@outlook.com", password: "Outlook2021") { (success, error) in
            
            sessionId = OnTheMapClient.Auth.sessionId
            uniqueKey = OnTheMapClient.Auth.uniqueKey

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
        XCTAssertGreaterThan(sessionId.count, 0)
        XCTAssertGreaterThan(uniqueKey.count, 0)
    }
}

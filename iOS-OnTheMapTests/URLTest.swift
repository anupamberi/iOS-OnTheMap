//
//  URLTest.swift
//  iOS-OnTheMapTests
//
//  Created by Anupam Beri on 02/04/2021.
//

import XCTest

class URLTest: XCTestCase {

    func testURLWithMultipleQueryParameters() throws {
        let url = URL(string: OnTheMapClient.Endpoints.getStudentLocation.stringValue)
        
        let urlQueryItems = [URLQueryItem(name: "limit", value: "100"),
                             URLQueryItem(name: "order", value: "-updatedAt")]
        
        let obtainedURL = url?.appending(urlQueryItems)
        let expectedURL = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt"
        XCTAssertEqual(obtainedURL?.absoluteString, expectedURL)
    }
    
    func testURLWithNoParameters() throws {
        let url = URL(string: OnTheMapClient.Endpoints.getStudentLocation.stringValue)

        let expectedURL = "https://onthemap-api.udacity.com/v1/StudentLocation"
        XCTAssertEqual(url?.absoluteString, expectedURL)
    }

}

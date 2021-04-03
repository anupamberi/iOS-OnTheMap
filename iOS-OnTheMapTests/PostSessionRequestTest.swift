//
//  PostSessionTest.swift
//  iOS-OnTheMapTests
//
//  Created by Anupam Beri on 29/03/2021.
//

import XCTest

class PostSessionRequestTest: XCTestCase {
    
    func testOK() throws {
        let postSessionJSON = Data("""
                {
                    "udacity": {
                        "username": "Anupam Beri",
                        "password": "udacity"
                    }
                }
                """.utf8)
        XCTAssertNoThrow(try JSONDecoder().decode(PostSessionRequest.self, from: postSessionJSON))
        let postSessionResponseObject = try JSONDecoder().decode(PostSessionRequest.self, from: postSessionJSON)
        XCTAssertNotNil(postSessionResponseObject.udacity)
        XCTAssertNotNil(postSessionResponseObject.udacity.username)
        XCTAssertNotNil(postSessionResponseObject.udacity.password)
    }

    func testError() throws {
        let postSessionJSON = Data("""
                {
                    "udacity": {
                        "userame": "Anupam Beri",
                        "password": "udacity"
                    }
                }
                """.utf8)
        XCTAssertThrowsError(try JSONDecoder().decode(PostSessionRequest.self, from: postSessionJSON))
    }
}

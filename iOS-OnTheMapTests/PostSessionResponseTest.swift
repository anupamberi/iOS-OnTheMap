//
//  PostSessionResponseTest.swift
//  iOS-OnTheMapTests
//
//  Created by Anupam Beri on 29/03/2021.
//

import XCTest

class PostSessionResponseTest: XCTestCase {

    func testOK() throws {

        let postSessionResponseJSON = Data("""
                {
                    "account": {
                        "registered": true,
                        "key": "549770910"
                    },
                    "session": {
                        "id": "7262691343Sd622da8a03967922060370b33ed73a76",
                        "expiration": "2021-03-30T19:43:36.673709Z"
                    }
                }
                """.utf8)
        
        XCTAssertNoThrow(try JSONDecoder().decode(PostSessionResponse.self, from: postSessionResponseJSON))
        let postSessionResponseObject = try JSONDecoder().decode(PostSessionResponse.self, from: postSessionResponseJSON)
        XCTAssertNotNil(postSessionResponseObject.account)
        XCTAssertNotNil(postSessionResponseObject.session)
    }

    func testError() throws {

        let postSessionResponseJSON = Data("""
                {
                    "accont": {
                        "registered": true,
                        "key": "549770910"
                    },
                    "session": {
                        "id": "7262691343Sd622da8a03967922060370b33ed73a76",
                        "expiration": "2021-03-30T19:43:36.673709Z"
                    }
                }
                """.utf8)
        
        XCTAssertThrowsError(try JSONDecoder().decode(PostSessionResponse.self, from: postSessionResponseJSON))
    }
    
    func testErrorResponse() throws {

        let postSessionErrorResponseJSON = Data("""
                {
                    "status": 403,
                    "error": "Account not found or invalid credentials."
                }
                """.utf8)
        
        XCTAssertNoThrow(try JSONDecoder().decode(PostSessionErrorResponse.self, from: postSessionErrorResponseJSON))
        let postSessionResponseObject = try JSONDecoder().decode(PostSessionErrorResponse.self, from: postSessionErrorResponseJSON)
        XCTAssertNotNil(postSessionResponseObject.status)
        XCTAssertNotNil(postSessionResponseObject.error)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

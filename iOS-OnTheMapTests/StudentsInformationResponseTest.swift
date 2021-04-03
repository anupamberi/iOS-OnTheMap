//
//  StudentsInformationResponseTest.swift
//  iOS-OnTheMapTests
//
//  Created by Anupam Beri on 29/03/2021.
//

import XCTest

class StudentsInformationResponseTest: XCTestCase {

    func testOK() throws {
        let studentsInformationResponse = Data("""
                {
                  "results": [
                    {
                      "firstName": "Armando",
                      "lastName": "Mosciski",
                      "longitude": 13.395172683522105,
                      "latitude": 52.51773324629952,
                      "mapString": "basil",
                      "mediaURL": "http://google.com",
                      "uniqueKey": "242884834",
                      "objectId": "ID10",
                      "createdAt": "2019-05-17T00:53:33.941Z",
                      "updatedAt": "2021-03-11T21:49:24.084Z"
                    },
                    {
                      "firstName": "first name",
                      "lastName": "last name",
                      "longitude": 39.8161028,
                      "latitude": 21.4029047,
                      "mapString": "mecca",
                      "mediaURL": "aa",
                      "uniqueKey": "1234",
                      "objectId": "ID11",
                      "createdAt": "2019-05-17T00:53:33.961Z",
                      "updatedAt": "2019-05-17T00:53:33.961Z"
                    },
                    {
                      "firstName": "John",
                      "lastName": "Doe",
                      "longitude": 39.8161028,
                      "latitude": 21.4029047,
                      "mapString": "Mountain View, CA",
                      "mediaURL": "https://udacity.com",
                      "uniqueKey": "1234",
                      "objectId": "ID12",
                      "createdAt": "2019-05-17T00:53:33.969Z",
                      "updatedAt": "2019-05-17T00:53:33.969Z"
                    }
                  ]
                }
                """.utf8)
        
        XCTAssertNoThrow(try JSONDecoder().decode(StudentsInformation.self, from: studentsInformationResponse))
        let studentsInfoResponseObject = try JSONDecoder().decode(StudentsInformation.self, from: studentsInformationResponse)
        XCTAssertNotNil(studentsInfoResponseObject.results)
        XCTAssertEqual(studentsInfoResponseObject.results.count, 3)
    }
}

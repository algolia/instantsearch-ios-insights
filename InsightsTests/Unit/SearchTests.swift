//
//  SearchTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 07/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

func XCTAssertInt64Equal(_ a: Int64, _ b: Int64, marginMS: Int64 = 50) {
    XCTAssertTrue(abs(a - b) < marginMS, "\(a) \(b)")
}

class SearchTests: XCTestCase {
    
    let eventProcessor = TestEventProcessor()
    let logger = Logger("test app id")
    var search: Search!
    
    override func setUp() {
        search = Search(eventProcessor: eventProcessor, logger: logger)
    }
    
    func testClick() {
        
        let expectedIndexName = "index name"
        let expectedUserToken = "user token"
        let expectedTimestamp = Date().millisecondsSince1970
        let expectedQueryID = "query id"
        let expectedObjectIDsWithPositions = [("o1", 1), ("o2", 2)]
        
        let exp = expectation(description: "Wait for event processor callback")
        
        eventProcessor.didProcess = { e in
            exp.fulfill()
            guard let click = e as? Click else {
                XCTFail("Click event expected")
                return
            }
            XCTAssertEqual(click.indexName, expectedIndexName)
            XCTAssertEqual(click.userToken, expectedUserToken)
            XCTAssertInt64Equal(click.timestamp, expectedTimestamp)
            XCTAssertEqual(click.queryID, expectedQueryID)
            XCTAssertEqual(click.objectIDsOrFilters, .objectIDs(expectedObjectIDsWithPositions.map { $0.0 }))
            XCTAssertEqual(click.positions, expectedObjectIDsWithPositions.map { $0.1 })
        }
        
        search.click(queryID: expectedQueryID,
                     userToken: expectedUserToken,
                     indexName: expectedIndexName,
                     timestamp: expectedTimestamp,
                     objectIDsWithPositions: expectedObjectIDsWithPositions)
        
        wait(for: [exp], timeout: 5)
        
    }
    
    func testConversion() {
        
        let expectedIndexName = "index name"
        let expectedUserToken = "user token"
        let expectedTimestamp: Int64 = Date().millisecondsSince1970
        let expectedQueryID = "query id"
        let expectedObjectIDs = ["o1", "o2"]
        
        let exp = expectation(description: "Wait for event processor callback")
        
        eventProcessor.didProcess = { e in
            exp.fulfill()
            guard let conversion = e as? Conversion else {
                XCTFail("Conversion event expected")
                return
            }
            XCTAssertEqual(conversion.indexName, expectedIndexName)
            XCTAssertEqual(conversion.userToken, expectedUserToken)
            XCTAssertInt64Equal(conversion.timestamp, expectedTimestamp)
            XCTAssertEqual(conversion.queryID, expectedQueryID)
            XCTAssertEqual(conversion.objectIDsOrFilters, .objectIDs(expectedObjectIDs))
        }
        
        search.conversion(queryID: expectedQueryID,
                          userToken: expectedUserToken,
                          indexName: expectedIndexName,
                          timestamp: expectedTimestamp,
                          objectIDs: expectedObjectIDs)
        
        wait(for: [exp], timeout: 5)
    }

    
}

//
//  ClickAnalyticsTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 07/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class ClickAnalyticsTests: XCTestCase {
    
    let indexName = "index name"
    let eventProcessor = TestEventProcessor()
    let clickAnalytics = ClickAnalytics(indexName: "index name")
    
    override func setUp() {
        clickAnalytics.eventProcessor = eventProcessor
    }
    
    func testClick() {
        
        let expectedIndexName = indexName
        let expectedUserToken = "user token"
        let expectedTimestamp = Date().timeIntervalSince1970
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
            XCTAssertEqual(click.timestamp, expectedTimestamp)
            XCTAssertEqual(click.queryID, expectedQueryID)
            XCTAssertEqual(click.objectIDsOrFilters, .objectIDs(expectedObjectIDsWithPositions.map { $0.0 }))
            XCTAssertEqual(click.positions, expectedObjectIDsWithPositions.map { $0.1 })
        }
        
        try! clickAnalytics.click(userToken: expectedUserToken,
                                  timestamp: expectedTimestamp,
                                  queryID: expectedQueryID,
                                  objectIDsWithPositions: expectedObjectIDsWithPositions)
        
        wait(for: [exp], timeout: 1)
        
    }
    
    func testConversion() {
        
        let expectedIndexName = indexName
        let expectedUserToken = "user token"
        let expectedTimestamp = Date().timeIntervalSince1970
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
            XCTAssertEqual(conversion.timestamp, expectedTimestamp)
            XCTAssertEqual(conversion.queryID, expectedQueryID)
            XCTAssertEqual(conversion.objectIDsOrFilters, .objectIDs(expectedObjectIDs))
        }
        
        try! clickAnalytics.conversion(userToken: expectedUserToken,
                                       timestamp: expectedTimestamp,
                                       queryID: expectedQueryID,
                                       objectIDs: expectedObjectIDs)
        
        wait(for: [exp], timeout: 1)
    }

    
}

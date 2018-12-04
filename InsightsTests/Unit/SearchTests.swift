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
        exp.expectedFulfillmentCount = 2
        
        eventProcessor.didProcess = { e in
            exp.fulfill()
            guard let click = e as? Click else {
                XCTFail("Click event expected")
                return
            }
            XCTAssertEqual(click.indexName, expectedIndexName)
            XCTAssertEqual(click.userToken, expectedUserToken)
            XCTAssertInt64Equal(click.timestamp, expectedTimestamp)
//            XCTAssertEqual(click.timestamp, expectedTimestamp)
            XCTAssertEqual(click.queryID, expectedQueryID)
            switch click.objectIDsOrFilters {
            case .objectIDs(let objectIDs) where objectIDs.count == 1:
                XCTAssertEqual(objectIDs.first, expectedObjectIDsWithPositions.first?.0)
                XCTAssertEqual(click.positions?.first, expectedObjectIDsWithPositions.first?.1)
                
            case .objectIDs(let objectIDs):
                XCTAssertEqual(objectIDs, expectedObjectIDsWithPositions.map { $0.0 })
                XCTAssertEqual(click.positions, expectedObjectIDsWithPositions.map { $0.1 })
                
            default:
                XCTFail("Unexpected filter value")
            }

        }
        
        search.click(userToken: expectedUserToken,
                     indexName: expectedIndexName,
                     timestamp: expectedTimestamp,
                     queryID: expectedQueryID,
                     objectIDsWithPositions: expectedObjectIDsWithPositions)
        
        search.click(userToken: expectedUserToken,
                     indexName: expectedIndexName,
                     timestamp: expectedTimestamp,
                     queryID: expectedQueryID,
                     objectID: expectedObjectIDsWithPositions.first!.0,
                     position: expectedObjectIDsWithPositions.first!.1)
        
        wait(for: [exp], timeout: 5)
        
    }
    
    func testConversion() {
        
        let expectedIndexName = "index name"
        let expectedUserToken = "user token"
        let expectedTimestamp: Int64 = Date().millisecondsSince1970
        let expectedQueryID = "query id"
        let expectedObjectIDs = ["o1", "o2"]
        
        let exp = expectation(description: "Wait for event processor callback")
        exp.expectedFulfillmentCount = 2
        
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
            switch conversion.objectIDsOrFilters {
            case .objectIDs(let objectIDs) where objectIDs.count == 1:
                XCTAssertEqual(objectIDs.first, expectedObjectIDs.first)
                
            case .objectIDs(let objectIDs):
                XCTAssertEqual(objectIDs, expectedObjectIDs)
                
            default:
                XCTFail("Unexpected filter value")
            }
        }
        
        search.conversion(userToken: expectedUserToken,
                          indexName: expectedIndexName,
                          timestamp: expectedTimestamp,
                          queryID: expectedQueryID,
                          objectIDs: expectedObjectIDs)
        
        search.conversion(userToken: expectedUserToken,
                          indexName: expectedIndexName,
                          timestamp: expectedTimestamp,
                          queryID: expectedQueryID,
                          objectID: expectedObjectIDs.first!)
        
        wait(for: [exp], timeout: 5)
    }

    
}

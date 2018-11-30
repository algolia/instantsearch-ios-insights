//
//  VisitTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 07/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class VisitTests: XCTestCase {
    
    let eventProcessor = TestEventProcessor()
    let logger = Logger("test app id")
    var visit: Visit!
    
    override func setUp() {
        visit = Visit(eventProcessor: eventProcessor, logger: logger)
    }
    
    func testViewEventWithObjects() {
        
        let expectedIndexName = "index name"
        let expectedEventName = "event name"
        let expectedUserToken = "user token"
        let expectedTimestamp = Date().millisecondsSince1970
        let expectedObjectIDs = ["o1", "o2"]
        
        let exp = expectation(description: "Wait for event processor callback")
        exp.expectedFulfillmentCount = 2

        eventProcessor.didProcess = { e in
            exp.fulfill()
            guard let view = e as? View else {
                XCTFail("View event expected")
                return
            }
            XCTAssertEqual(view.indexName, expectedIndexName)
            XCTAssertEqual(view.name, expectedEventName)
            XCTAssertEqual(view.userToken, expectedUserToken)
            XCTAssertEqual(view.timestamp, expectedTimestamp)
            XCTAssertNil(view.queryID)
            switch view.objectIDsOrFilters {
            case .objectIDs(let objectIDs) where objectIDs.count == 1:
                XCTAssertEqual(objectIDs.first!, expectedObjectIDs.first!)
                
            case .objectIDs(let objectIDs):
                XCTAssertEqual(objectIDs, expectedObjectIDs)
                
            default:
                XCTFail("Unexpected filters value")
            }

        }

        visit.view(eventName: expectedEventName,
                   indexName: expectedIndexName,
                   userToken: expectedUserToken,
                   timestamp: expectedTimestamp,
                   objectIDs: expectedObjectIDs)
        
        visit.view(eventName: expectedEventName,
                   indexName: expectedIndexName,
                   userToken: expectedUserToken,
                   timestamp: expectedTimestamp,
                   objectID: expectedObjectIDs.first!)
        
        wait(for: [exp], timeout: 5)
        
    }
    
    func testViewEventWithFilters() {
        
        let expectedIndexName = "index name"
        let expectedEventName = "event name"
        let expectedUserToken = "user token"
        let expectedTimestamp = Date().millisecondsSince1970
        let expectedFilters = ["brand:apple", "color:red"]
        
        let exp = expectation(description: "Wait for event processor callback")
        
        eventProcessor.didProcess = { e in
            exp.fulfill()
            guard let view = e as? View else {
                XCTFail("View event expected")
                return
            }
            XCTAssertEqual(view.indexName, expectedIndexName)
            XCTAssertEqual(view.name, expectedEventName)
            XCTAssertEqual(view.userToken, expectedUserToken)
            XCTAssertEqual(view.timestamp, expectedTimestamp)
            XCTAssertNil(view.queryID)
            XCTAssertEqual(view.objectIDsOrFilters, .filters(expectedFilters))
            
        }
        
        visit.view(eventName: expectedEventName,
                             indexName: expectedIndexName,
                             userToken: expectedUserToken,
                             timestamp: expectedTimestamp,
                               filters: expectedFilters)
        
        wait(for: [exp], timeout: 5)

        
    }
    
    func testClickEventWithObjects() {
        
        let expectedIndexName = "index name"
        let expectedEventName = "event name"
        let expectedUserToken = "user token"
        let expectedTimestamp = Date().millisecondsSince1970
        let expectedObjectIDs = ["o1", "o2"]
        
        let exp = expectation(description: "Wait for event processor callback")
        exp.expectedFulfillmentCount = 2
        
        eventProcessor.didProcess = { e in
            exp.fulfill()
            guard let click = e as? Click else {
                XCTFail("Click event expected")
                return
            }
            XCTAssertEqual(click.indexName, expectedIndexName)
            XCTAssertEqual(click.name, expectedEventName)
            XCTAssertEqual(click.userToken, expectedUserToken)
            XCTAssertEqual(click.timestamp, expectedTimestamp)
            XCTAssertNil(click.queryID)
            switch click.objectIDsOrFilters {
            case .objectIDs(let objectIDs) where objectIDs.count == 1:
                XCTAssertEqual(objectIDs.first, expectedObjectIDs.first)
            case .objectIDs(let objectIDs):
                XCTAssertEqual(objectIDs, expectedObjectIDs)
            default:
                XCTFail("Unexpected filters value")
            }
            
        }
        
        visit.click(eventName: expectedEventName,
                              indexName: expectedIndexName,
                              userToken: expectedUserToken,
                              timestamp: expectedTimestamp,
                              objectIDs: expectedObjectIDs)
        
        visit.click(eventName: expectedEventName,
                    indexName: expectedIndexName,
                    userToken: expectedUserToken,
                    timestamp: expectedTimestamp,
                    objectID: expectedObjectIDs.first!)
        
        wait(for: [exp], timeout: 5)

        
    }
    
    func testClickEventWithFilters() {
        
        let expectedIndexName = "index name"
        let expectedEventName = "event name"
        let expectedUserToken = "user token"
        let expectedTimestamp = Date().millisecondsSince1970
        let expectedFilters = ["brand:apple", "color:red"]
        
        let exp = expectation(description: "Wait for event processor callback")
        
        eventProcessor.didProcess = { e in
            exp.fulfill()
            guard let click = e as? Click else {
                XCTFail("Click event expected")
                return
            }
            XCTAssertEqual(click.indexName, expectedIndexName)
            XCTAssertEqual(click.name, expectedEventName)
            XCTAssertEqual(click.userToken, expectedUserToken)
            XCTAssertEqual(click.timestamp, expectedTimestamp)
            XCTAssertNil(click.queryID)
            XCTAssertEqual(click.objectIDsOrFilters, .filters(expectedFilters))
            
        }
        
        visit.click(eventName: expectedEventName,
                              indexName: expectedIndexName,
                              userToken: expectedUserToken,
                              timestamp: expectedTimestamp,
                                filters: expectedFilters)
        
        wait(for: [exp], timeout: 5)

        
    }
    
    func testConversionEventWithObjects() {
        
        let expectedIndexName = "index name"
        let expectedEventName = "event name"
        let expectedUserToken = "user token"
        let expectedTimestamp = Date().millisecondsSince1970
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
            XCTAssertEqual(conversion.name, expectedEventName)
            XCTAssertEqual(conversion.userToken, expectedUserToken)
            XCTAssertEqual(conversion.timestamp, expectedTimestamp)
            XCTAssertNil(conversion.queryID)
            switch conversion.objectIDsOrFilters {
            case .objectIDs(let objectIDs) where objectIDs.count == 1:
                XCTAssertEqual(objectIDs.first, expectedObjectIDs.first)
            case .objectIDs(let objectIDs):
                XCTAssertEqual(objectIDs, expectedObjectIDs)
            default:
                XCTFail("Unexpected filters value")
            }

        }
        
        visit.conversion(eventName: expectedEventName,
                                   indexName: expectedIndexName,
                                   userToken: expectedUserToken,
                                   timestamp: expectedTimestamp,
                                   objectIDs: expectedObjectIDs)
        
        visit.conversion(eventName: expectedEventName,
                         indexName: expectedIndexName,
                         userToken: expectedUserToken,
                         timestamp: expectedTimestamp,
                         objectID: expectedObjectIDs.first!)
        
        wait(for: [exp], timeout: 5)
        
    }
    
    func testConversionEventWithFilters() {
        
        let expectedIndexName = "index name"
        let expectedEventName = "event name"
        let expectedUserToken = "user token"
        let expectedTimestamp = Date().millisecondsSince1970
        let expectedFilters = ["brand:apple", "color:red"]

        let exp = expectation(description: "Wait for event processor callback")
        
        eventProcessor.didProcess = { e in
            exp.fulfill()
            guard let conversion = e as? Conversion else {
                XCTFail("Conversion event expected")
                return
            }
            XCTAssertEqual(conversion.indexName, expectedIndexName)
            XCTAssertEqual(conversion.name, expectedEventName)
            XCTAssertEqual(conversion.userToken, expectedUserToken)
            XCTAssertEqual(conversion.timestamp, expectedTimestamp)
            XCTAssertNil(conversion.queryID)
            XCTAssertEqual(conversion.objectIDsOrFilters, .filters(expectedFilters))
            
        }
        
        visit.conversion(eventName: expectedEventName,
                         indexName: expectedIndexName,
                         userToken: expectedUserToken,
                         timestamp: expectedTimestamp,
                         filters: expectedFilters)
        
        wait(for: [exp], timeout: 5)

        
    }
    
}


//
//  PersonalizationTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 07/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class PersonalizationTests: XCTestCase {
    
    let eventProcessor = TestEventProcessor()
    let logger = Logger("test app id")
    var personalization: Personalization!
    
    override func setUp() {
        personalization = Personalization(eventProcessor: eventProcessor, logger: logger)
    }
    
    func testViewEventWithObjects() {
        
        let expectedIndexName = "index name"
        let expectedEventName = "event name"
        let expectedUserToken = "user token"
        let expectedTimestamp = Date().timeIntervalSince1970
        let expectedObjectIDs = ["o1", "o2"]
        
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
            XCTAssertEqual(view.objectIDsOrFilters, .objectIDs(expectedObjectIDs))

        }

        personalization.view(eventName: expectedEventName,
                             indexName: expectedIndexName,
                             userToken: expectedUserToken,
                             timestamp: expectedTimestamp,
                             objectIDs: expectedObjectIDs)
        
        wait(for: [exp], timeout: 5)
        
    }
    
    func testViewEventWithFilters() {
        
        let expectedIndexName = "index name"
        let expectedEventName = "event name"
        let expectedUserToken = "user token"
        let expectedTimestamp = Date().timeIntervalSince1970
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
        
        personalization.view(eventName: expectedEventName,
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
        let expectedTimestamp = Date().timeIntervalSince1970
        let expectedObjectIDs = ["o1", "o2"]
        
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
            XCTAssertEqual(click.objectIDsOrFilters, .objectIDs(expectedObjectIDs))
            
        }
        
        personalization.click(eventName: expectedEventName,
                              indexName: expectedIndexName,
                              userToken: expectedUserToken,
                              timestamp: expectedTimestamp,
                              objectIDs: expectedObjectIDs)
        
        wait(for: [exp], timeout: 5)

        
    }
    
    func testClickEventWithFilters() {
        
        let expectedIndexName = "index name"
        let expectedEventName = "event name"
        let expectedUserToken = "user token"
        let expectedTimestamp = Date().timeIntervalSince1970
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
        
        personalization.click(eventName: expectedEventName,
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
        let expectedTimestamp = Date().timeIntervalSince1970
        let expectedObjectIDs = ["o1", "o2"]
        
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
            XCTAssertEqual(conversion.objectIDsOrFilters, .objectIDs(expectedObjectIDs))
            
        }
        
        personalization.conversion(eventName: expectedEventName,
                                   indexName: expectedIndexName,
                                   userToken: expectedUserToken,
                                   timestamp: expectedTimestamp,
                                   objectIDs: expectedObjectIDs)
        
        wait(for: [exp], timeout: 5)

        
    }
    
    func testConversionEventWithFilters() {
        
        let expectedIndexName = "index name"
        let expectedEventName = "event name"
        let expectedUserToken = "user token"
        let expectedTimestamp = Date().timeIntervalSince1970
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
        
        personalization.conversion(eventName: expectedEventName,
                                   indexName: expectedIndexName,
                                   userToken: expectedUserToken,
                                   timestamp: expectedTimestamp,
                                     filters: expectedFilters)
        
        wait(for: [exp], timeout: 5)

        
    }
    
}


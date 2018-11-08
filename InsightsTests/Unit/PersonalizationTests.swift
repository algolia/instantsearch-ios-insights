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
    
    let indexName = "index name"
    let eventProcessor = TestEventProcessor()
    let personalization = Personalization(indexName: "index name")
    
    override func setUp() {
        personalization.eventProcessor = eventProcessor
    }
    
    func testViewEventWithObjects() {
        
        let expectedIndexName = indexName
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

        try! personalization.view(eventName: expectedEventName,
                                  userToken: expectedUserToken,
                                  timestamp: expectedTimestamp,
                                  objectIDs: expectedObjectIDs)
        
        wait(for: [exp], timeout: 1)
        
    }
    
    func testViewEventWithFilters() {
        
        let expectedIndexName = indexName
        let expectedEventName = "event name"
        let expectedUserToken = "user token"
        let expectedTimestamp = Date().timeIntervalSince1970
        let expectedFilters = [Filter(rawValue: "brand:apple")!, Filter(rawValue: "color:red")!]
        
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
        
        try! personalization.view(eventName: expectedEventName,
                                  userToken: expectedUserToken,
                                  timestamp: expectedTimestamp,
                                  filters: expectedFilters)
        
        wait(for: [exp], timeout: 1)

        
    }
    
    func testClickEventWithObjects() {
        
        let expectedIndexName = indexName
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
        
        try! personalization.click(eventName: expectedEventName,
                                  userToken: expectedUserToken,
                                  timestamp: expectedTimestamp,
                                  objectIDs: expectedObjectIDs)
        
        wait(for: [exp], timeout: 1)

        
    }
    
    func testClickEventWithFilters() {
        
        let expectedIndexName = indexName
        let expectedEventName = "event name"
        let expectedUserToken = "user token"
        let expectedTimestamp = Date().timeIntervalSince1970
        let expectedFilters = [Filter(rawValue: "brand:apple")!, Filter(rawValue: "color:red")!]
        
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
        
        try! personalization.click(eventName: expectedEventName,
                                  userToken: expectedUserToken,
                                  timestamp: expectedTimestamp,
                                  filters: expectedFilters)
        
        wait(for: [exp], timeout: 1)

        
    }
    
    func testConversionEventWithObjects() {
        
        let expectedIndexName = indexName
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
        
        try! personalization.conversion(eventName: expectedEventName,
                                        userToken: expectedUserToken,
                                        timestamp: expectedTimestamp,
                                        objectIDs: expectedObjectIDs)
        
        wait(for: [exp], timeout: 1)

        
    }
    
    func testConversionEventWithFilters() {
        
        let expectedIndexName = indexName
        let expectedEventName = "event name"
        let expectedUserToken = "user token"
        let expectedTimestamp = Date().timeIntervalSince1970
        let expectedFilters = [Filter(rawValue: "brand:apple")!, Filter(rawValue: "color:red")!]
        
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
        
        try! personalization.conversion(eventName: expectedEventName,
                                        userToken: expectedUserToken,
                                        timestamp: expectedTimestamp,
                                        filters: expectedFilters)
        
        wait(for: [exp], timeout: 1)

        
    }
    
}


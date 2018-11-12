//
//  WebServiceIntegrationTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 08/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class WebServiceIntegrationTests: XCTestCase {

    let appId = "932LAAGOT3"
    let apiKey = "6a187532e8e703464da52c20555c37cf"
    let indexName = "ios@algolia.com#atis-prod"
    let userToken = "123"
    let timestamp = Date().timeIntervalSince1970
    let queryID = "6de2f7eaa537fa93d8f8f05b927953b1"
    let objectIDs = ["61992275", "62300547"]
    let filters = ["brand:HarperCollins"]
    
    func testClickEvent() {
        
        let exp = expectation(description: "ws response")
        
        let sessionConfig =  Algolia.SessionConfig.default(appId: appId, apiKey: apiKey)
        let logger = Logger(appId)
        let webService = WebService(sessionConfig: sessionConfig, logger: logger)
        
        let event = try! Click(name: "test click",
                               indexName: indexName,
                               userToken: userToken,
                               timestamp: timestamp,
                               objectIDsOrFilters: .objectIDs(objectIDs),
                               positions: .none)
        
        let eventsPackage = EventsPackage(event: EventWrapper.click(event))
        
        webService.sync(event: eventsPackage) { error in
            exp.fulfill()
            XCTAssertNil(error, "Expected no error, occured: \(String(describing: error))")
        }

        wait(for: [exp], timeout: 2)
        
    }
    
    func testClickEventWithPositions() {
        
        let exp = expectation(description: "ws response")
        
        let sessionConfig =  Algolia.SessionConfig.default(appId: appId, apiKey: apiKey)
        let logger = Logger(appId)
        let webService = WebService(sessionConfig: sessionConfig, logger: logger)
        
        let event = try! Click(name: "test click",
                               indexName: indexName,
                               userToken: userToken,
                               timestamp: timestamp,
                               queryID: queryID,
                               objectIDsWithPositions: [(objectIDs.first!, 1)])
        
        let eventsPackage = EventsPackage(event: EventWrapper.click(event))
        
        webService.sync(event: eventsPackage) { error in
            exp.fulfill()
            XCTAssertNil(error, "Expected no error, occured: \(String(describing: error))")
        }
        
        wait(for: [exp], timeout: 2)
        
    }
    
    func testViewEvent() {
        
        let exp = expectation(description: "ws response")
        
        let sessionConfig = Algolia.SessionConfig.default(appId: appId, apiKey: apiKey)
        let logger = Logger(appId)
        let webService = WebService(sessionConfig: sessionConfig, logger: logger)
        
        let event = try! View(name: "test view",
                              indexName: indexName,
                              userToken: userToken,
                              timestamp: timestamp,
                              queryID: queryID,
                              objectIDsOrFilters: .filters(filters))
        
        let eventsPackage = EventsPackage(event: EventWrapper.view(event))
        
        webService.sync(event: eventsPackage) { error in
            exp.fulfill()
            XCTAssertNil(error, "Expected no error, occured: \(String(describing: error))")
        }
        
        wait(for: [exp], timeout: 2)

    }
    
    func testConversionEvent() {
        
        let exp = expectation(description: "ws response")
        
        let sessionConfig = Algolia.SessionConfig.default(appId: appId, apiKey: apiKey)
        let logger = Logger(appId)
        let webService = WebService(sessionConfig: sessionConfig, logger: logger)
        
        let event = try! Conversion(name: "test conversion",
                                    indexName: indexName,
                                    userToken: userToken,
                                    timestamp: timestamp,
                                    queryID: queryID,
                                    objectIDsOrFilters: .objectIDs(objectIDs))
        
        let eventsPackage = EventsPackage(event: EventWrapper.conversion(event))
        
        webService.sync(event: eventsPackage) { error in
            exp.fulfill()
            XCTAssertNil(error, "Expected no error, occured: \(String(describing: error))")
        }
        
        wait(for: [exp], timeout: 2)

    }
    
    func testEventsPackage() {
        
        let exp = expectation(description: "ws response")
        
        let sessionConfig = Algolia.SessionConfig.default(appId: appId, apiKey: apiKey)
        let logger = Logger(appId)
        let webService = WebService(sessionConfig: sessionConfig, logger: logger)
        
        let conversion = try! Conversion(name: "test conversion",
                                         indexName: indexName,
                                         userToken: userToken,
                                         timestamp: timestamp,
                                         queryID: queryID,
                                         objectIDsOrFilters: .objectIDs(objectIDs))
        
        let view = try! View(name: "test view",
                             indexName: indexName,
                             userToken: userToken,
                             timestamp: timestamp,
                             queryID: queryID,
                             objectIDsOrFilters: .filters(filters))
        
        let click = try! Click(name: "test click",
                               indexName: indexName,
                               userToken: userToken,
                               timestamp: timestamp,
                               queryID: queryID,
                               objectIDsWithPositions: [(objectIDs.first!, 1)])


        let eventsPackage = try! EventsPackage(events: [.conversion(conversion), .view(view), .click(click)])
        
        webService.sync(event: eventsPackage) { error in
            exp.fulfill()
            XCTAssertNil(error, "Expected no error, occured: \(String(describing: error))")
        }
        
        wait(for: [exp], timeout: 2)
        
    }
    
}

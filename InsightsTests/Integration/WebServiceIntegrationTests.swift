//
//  WebServiceIntegrationTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 08/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

/**
 Correct environment variables
 - ALGOLIA_APPLICATION_ID
 - ALGOLIA_API_KEY
 - ALGOLIA_INDEX_NAME
 
 must be defined to make this test succeed
*/

class WebServiceIntegrationTests: XCTestCase {
    
    private func envVar(forKey key: String) -> String? {
        if let value = Bundle(for: type(of: self)).object(forInfoDictionaryKey: key) as? String, !value.isEmpty {
            return value
        } else if let value = ProcessInfo.processInfo.environment[key], !value.isEmpty {
            return value
        } else {
            return nil
        }
    }
    
    lazy var appId: String = {
        guard let appId = envVar(forKey: "ALGOLIA_APPLICATION_ID") else {
            XCTFail("Missing test app id")
            return ""
        }
        return appId
    }()
    
    lazy var apiKey: String = {
        guard let apiKey = envVar(forKey: "ALGOLIA_API_KEY") else {
            XCTFail("Missing test api key")
            return ""
        }
        return apiKey
    }()
    
    lazy var indexName: String = {
        guard let indexName = envVar(forKey: "ALGOLIA_INDEX_NAME") else {
            XCTFail("Missing test index name")
            return ""
        }
        return indexName
    }()
    
    let userToken = "123"
    let timestamp = Date().millisecondsSince1970
    let queryID = "6de2f7eaa537fa93d8f8f05b927953b1"
    let objectIDs = ["61992275", "62300547"]
    let filters = ["brand:HarperCollins"]
    
    func testClickEvent() {
        
        let exp = expectation(description: "ws response")
        var completionCallCount = 0

        let sessionConfig = Algolia.SessionConfig.default(appId: appId, apiKey: apiKey)
        let logger = Logger(appId)
        let webService = WebService(sessionConfig: sessionConfig, logger: logger)
        
        let event = try! Click(name: "test click",
                               indexName: indexName,
                               userToken: userToken,
                               timestamp: timestamp,
                               objectIDsOrFilters: .objectIDs(objectIDs),
                               positions: .none)
        
        let eventsPackage = EventsPackage(event: EventWrapper.click(event))
        
        webService.sync(eventsPackage) { error in
            completionCallCount = completionCallCount + 1
            XCTAssertEqual(completionCallCount, 1, "Completion must be called once")
            XCTAssertNil(error, "Expected no error, occured: \(String(describing: error))")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5)
        
    }
    
    func testClickEventWithPositions() {
        
        let exp = expectation(description: "ws response")
        var completionCallCount = 0

        let sessionConfig = Algolia.SessionConfig.default(appId: appId, apiKey: apiKey)
        let logger = Logger(appId)
        let webService = WebService(sessionConfig: sessionConfig, logger: logger)
        
        let event = try! Click(name: "test click",
                               indexName: indexName,
                               userToken: userToken,
                               timestamp: timestamp,
                               queryID: queryID,
                               objectIDsWithPositions: [(objectIDs.first!, 1)])
        
        let eventsPackage = EventsPackage(event: EventWrapper.click(event))
        
        webService.sync(eventsPackage) { error in
            completionCallCount = completionCallCount + 1
            XCTAssertEqual(completionCallCount, 1, "Completion must be called once")
            XCTAssertNil(error, "Expected no error, occured: \(String(describing: error))")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
        
    }
    
    func testViewEvent() {
        
        let exp = expectation(description: "ws response")
        var completionCallCount = 0

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
        
        webService.sync(eventsPackage) { error in
            completionCallCount = completionCallCount + 1
            XCTAssertEqual(completionCallCount, 1, "Completion must be called once")
            XCTAssertNil(error, "Expected no error, occured: \(String(describing: error))")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)

    }
    
    func testConversionEvent() {
        
        let exp = expectation(description: "ws response")
        var completionCallCount = 0

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
        
        webService.sync(eventsPackage) { error in
            completionCallCount = completionCallCount + 1
            XCTAssertEqual(completionCallCount, 1, "Completion must be called once")
            XCTAssertNil(error, "Expected no error, occured: \(String(describing: error))")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)

    }
    
    func testEventsPackage() {
        
        let exp = expectation(description: "ws response")
        var completionCallCount = 0
        
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
        
        webService.sync(eventsPackage) { error in
            completionCallCount = completionCallCount + 1
            XCTAssertEqual(completionCallCount, 1, "Completion must be called once")
            XCTAssertNil(error, "Expected no error, occured: \(String(describing: error))")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
        
    }
    
}

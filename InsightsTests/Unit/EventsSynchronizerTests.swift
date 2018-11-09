//
//  EventsSynchronizerTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 08/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class EventsSynchronizerTests: XCTestCase {
    
    let appId = "test app id"
    
    override func setUp() {
        //Remove locally stored events packages
        let fileName = "\(appId).events"
        if let fp = LocalStorage<[EventsPackage]>.filePath(for: fileName) {
            LocalStorage<[EventsPackage]>.serialize([], file: fp)
        }
    }
    
    
    func testPackageAssembly() {
        
        let mockWS = MockWebServiceHelper.getMockWebService(appId: appId) { _ in }
        
        let credentials = Credentials(appId: appId, apiKey: "APIKEY")
        let eventsSynchronizer = EventsSynchronizer(credentials: credentials,
                                                    webService: mockWS,
                                                    flushDelay: 1000,
                                                    logger: Logger(appId))
        
        eventsSynchronizer.isLocalStorageEnabled = false
        eventsSynchronizer.syncProcess(TestEvent.template)
        
        XCTAssertEqual(eventsSynchronizer.eventsPackages.count, 1)
        
        eventsSynchronizer.syncProcess(TestEvent.template)
        
        XCTAssertEqual(eventsSynchronizer.eventsPackages.count, 1)
        XCTAssertEqual(eventsSynchronizer.eventsPackages.first?.events.count, 2)
        
        let events = [Event](repeating: TestEvent.template, count: 1000)
        
        events.forEach(eventsSynchronizer.syncProcess)
        
        XCTAssertEqual(eventsSynchronizer.eventsPackages.count, 2)
        
        
    }
    
    func testSync() {
        
        let wsExpectation = expectation(description: "expectation for ws response")
        
        let mockWS = MockWebServiceHelper.getMockWebService(appId: appId) { _ in
            wsExpectation.fulfill()
        }

        let credentials = Credentials(appId: appId, apiKey: "APIKEY")
        let eventsSynchronizer = EventsSynchronizer(credentials: credentials,
                                                    webService: mockWS,
                                                    flushDelay: 1000,
                                                    logger: Logger(appId))
        
        eventsSynchronizer.isLocalStorageEnabled = false

        eventsSynchronizer.syncProcess(TestEvent.template)
        eventsSynchronizer.flush(eventsSynchronizer.eventsPackages)
        
        wait(for: [wsExpectation], timeout: 2)
    }
    
}

//
//  EventsProcessorTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 08/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class EventsProcessorTests: XCTestCase {
    
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
        
        let queue = DispatchQueue(label: "test queue", qos: .default)
        let credentials = Credentials(appId: appId, apiKey: "APIKEY")
        let eventsProcessor = EventsProcessor(credentials: credentials,
                                              webService: mockWS,
                                              flushDelay: 1000,
                                              logger: Logger(appId),
                                              dispatchQueue: queue)
        
        eventsProcessor.isLocalStorageEnabled = false
        eventsProcessor.process(TestEvent.template)
        
        queue.sync {}
        XCTAssertEqual(eventsProcessor.eventsPackages.count, 1)

        eventsProcessor.process(TestEvent.template)
        
        queue.sync {}
        
        XCTAssertEqual(eventsProcessor.eventsPackages.count, 1)
        XCTAssertEqual(eventsProcessor.eventsPackages.first?.events.count, 2)
        
        print(eventsProcessor.eventsPackages)
        
        let events = [Event](repeating: TestEvent.template, count: EventsPackage.maxEventCountInPackage)
        
        events.forEach(eventsProcessor.process)
        
        queue.sync {}
        
        print(eventsProcessor.eventsPackages)
        
        XCTAssertEqual(eventsProcessor.eventsPackages.count, 2)
        XCTAssertEqual(eventsProcessor.eventsPackages.first?.count, EventsPackage.maxEventCountInPackage)
        XCTAssertEqual(eventsProcessor.eventsPackages.last?.count, 2)
        
    }
    
    func testSync() {
        
        let wsExpectation = expectation(description: "expectation for ws response")
        
        let mockWS = MockWebServiceHelper.getMockWebService(appId: appId) { _ in
            wsExpectation.fulfill()
        }
        let queue = DispatchQueue(label: "test queue")
        let credentials = Credentials(appId: appId, apiKey: "APIKEY")
        let eventsProcessor = EventsProcessor(credentials: credentials,
                                              webService: mockWS,
                                              flushDelay: 1000,
                                              logger: Logger(appId),
                                              dispatchQueue: queue)
        
        eventsProcessor.isLocalStorageEnabled = false

        eventsProcessor.process(TestEvent.template)
        queue.sync {}
        eventsProcessor.flushEventsPackages()
        
        wait(for: [wsExpectation], timeout: 5)
    }
    
}

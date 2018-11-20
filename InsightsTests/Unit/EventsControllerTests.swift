//
//  EventsControllerTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 08/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class EventsControllerTests: XCTestCase {
    
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
        let eventsController = EventsController(credentials: credentials,
                                                    webService: mockWS,
                                                    flushDelay: 1000,
                                                    logger: Logger(appId),
                                                    dispatchQueue: queue)
        
        eventsController.isLocalStorageEnabled = false
        eventsController.process(TestEvent.template)
        
        queue.sync {}
        XCTAssertEqual(eventsController.eventsPackages.count, 1)

        eventsController.process(TestEvent.template)
        
        queue.sync {}
        
        XCTAssertEqual(eventsController.eventsPackages.count, 1)
        XCTAssertEqual(eventsController.eventsPackages.first?.events.count, 2)
        
        let events = [Event](repeating: TestEvent.template, count: 1000)
        
        events.forEach(eventsController.process)
        
        queue.sync {}
        
        XCTAssertEqual(eventsController.eventsPackages.count, 2)
        
    }
    
    func testSync() {
        
        let wsExpectation = expectation(description: "expectation for ws response")
        
        let mockWS = MockWebServiceHelper.getMockWebService(appId: appId) { _ in
            wsExpectation.fulfill()
        }
        let queue = DispatchQueue(label: "test queue")
        let credentials = Credentials(appId: appId, apiKey: "APIKEY")
        let eventsController = EventsController(credentials: credentials,
                                                    webService: mockWS,
                                                    flushDelay: 1000,
                                                    logger: Logger(appId),
                                                    dispatchQueue: queue)
        
        eventsController.isLocalStorageEnabled = false

        eventsController.process(TestEvent.template)
        queue.sync {}
        eventsController.flush(eventsController.eventsPackages)
        
        wait(for: [wsExpectation], timeout: 5)
    }
    
}

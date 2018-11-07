//
//  InsightsTests.swift
//  InsightsTests
//
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class InsightsTests: XCTestCase {
    
    override func setUp() {
        // Remove locally stored events packages for test index
        guard let filePath = LocalStorage<[EventsPackage]>.filePath(for: "testIndex") else { return }
        LocalStorage<[EventsPackage]>.serialize([], file: filePath)
    }
  
    func testInitShouldFail() {
        let insightsRegister = Insights.shared(index: "test")
        XCTAssertNil(insightsRegister)
        
    }
    
    func testInitShouldWork() {
        
        let indexName = "testIndex"
        
        let insightsRegister = Insights.register(appId: "testApp", apiKey: "testKey", indexName: indexName)
        XCTAssertNotNil(insightsRegister)
        
        let insightsShared = Insights.shared(index: indexName)
        XCTAssertNotNil(insightsShared)
        
        XCTAssertEqual(insightsRegister, insightsShared, "Getting the Insights instance from register and shared should be the same")
        
    }

    func testEventIsSentCorrectly() {
        let expectation = self.expectation(description: "Wait for nothing")
        let indexName = "testIndex"
        
        let expectedEventName = "My super event"
        
        let mockWS = MockWebServiceHelper.getMockWebService(indexName: indexName) { resource in
            if let res = resource as? Resource<Bool, WebserviceError> {
                XCTAssertEqual(res.method.method, "POST")
                _ = res.method.map(f: { data in
                    XCTAssertNotNil(data)
                    let jsonDecoder = JSONDecoder()
                    do {
                        let package = try jsonDecoder.decode(EventsPackage.self, from: data)
                        XCTAssertEqual(package.events.count, 1)
                    } catch _ {
                        XCTFail("Unable to construct EventsPackage with provided JSON")
                    }
                })
                expectation.fulfill()
            } else {
                XCTFail("Unable to cast resource")
            }
        }
        
        let insightsRegister = Insights(credentials: Credentials(appId: "dummyAppId",
                                                                 apiKey: "dummyApiKey",
                                                                 indexName: indexName),
                                        webService: mockWS,
                                        flushDelay: 10,
                                        logger: Logger(indexName))
     
        let clickEvent = try! Click(name: expectedEventName, index: indexName, userToken: "Test user token", queryID: "6de2f7eaa537fa93d8f8f05b927953b1", objectIDsWithPositions: [("ObjectID", 1)])
        
        insightsRegister.process(clickEvent)
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
}

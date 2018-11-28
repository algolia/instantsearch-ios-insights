//
//  InsightsTests.swift
//  InsightsTests
//
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class InsightsTests: XCTestCase {
    
    let testCredentials = Credentials(appId: "test app id", apiKey: "test key")
    
    override func setUp() {
        // Remove locally stored events packages for test index
        guard let filePath = LocalStorage<[EventsPackage]>.filePath(for: testCredentials.appId) else { return }
        LocalStorage<[EventsPackage]>.serialize([], file: filePath)
    }
  
    func testInitShouldFail() {
        let insightsRegister = Insights.shared(appId: "test")
        XCTAssertNil(insightsRegister)
        
        Insights.register(appId: "app1", apiKey: "key1")
        Insights.register(appId: "app2", apiKey: "key2")
        
        XCTAssertNil(Insights.shared)
    }
    
    func testInitShouldWork() {
        
        let insightsRegister = Insights.register(appId: testCredentials.appId, apiKey: "testKey")
        XCTAssertNotNil(insightsRegister)
        
        let insightsShared = Insights.shared(appId: testCredentials.appId)
        XCTAssertNotNil(insightsShared)
        
        XCTAssertEqual(insightsRegister, insightsShared, "Getting the Insights instance from register and shared should be the same")
        
    }

    func testEventIsSentCorrectly() {
        let expectation = self.expectation(description: "Wait for nothing")
        let expectedIndexName = "test index name"
        let expectedUserToken = "test user token"
        let expectedQueryID = "6de2f7eaa537fa93d8f8f05b927953b1"
        let expectedObjectIDsWithPositions = [("o1", 1)]
        
        let mockWS = MockWebServiceHelper.getMockWebService(appId: testCredentials.appId) { resource in
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
        
        let insightsRegister = Insights(credentials: Credentials(appId: testCredentials.appId,
                                                                 apiKey: "testKey"),
                                        webService: mockWS,
                                        flushDelay: 1,
                                        logger: Logger(testCredentials.appId))
     
        
        insightsRegister.search.click(userToken: expectedUserToken,
                                      indexName: expectedIndexName,
                                      queryID: expectedQueryID,
                                      objectIDsWithPositions: expectedObjectIDsWithPositions)
        
        Insights.shared?.search.click(userToken: "user token",
                                      indexName: "my index",
                                      queryID: "q123",
                                      objectIDsWithPositions: [("obj1", 1), ("obj2", 2)])
        
        Insights.shared?.search.conversion(userToken: "user token",
                                           indexName: "my index",
                                           queryID: "q123",
                                           objectIDs: ["obj1", "obj2"])
        
        Insights.shared?.visit.view(eventName: "View event",
                                    indexName: "my index",
                                    userToken: "user token",
                                    filters: ["brand:apple"])

        
        Insights.shared(appId: "app id")?.search.click(userToken: "user token",
                                                       indexName: "my index",
                                                       queryID: "q123",
                                                       objectIDsWithPositions: [("obj1", 1), ("obj2", 2)])
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
}

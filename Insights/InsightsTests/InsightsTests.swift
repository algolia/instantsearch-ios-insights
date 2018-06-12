//
//  InsightsTests.swift
//  InsightsTests
//
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import Insights

class InsightsTests: XCTestCase {
  
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
    var expectedData: [String : Any] = [
      "eventName": "My super event",
      "queryID": "6de2f7eaa537fa93d8f8f05b927953b1",
      "position": 1,
      "objectID": "54675051",
      "indexName": "support_rmogos",
      "timestamp": Date.timeIntervalBetween1970AndReferenceDate
    ]
    
    let mockWS = MockWebServiceHelper.getMockWebService(indexName: indexName) { resource in
      if let res = resource as? Resource<Bool, WebserviceError> {
        XCTAssertEqual(res.method.method, "POST")
        res.method.map(f: { data in
          XCTAssertNotNil(data)
          do {
            guard let actualData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
              XCTFail("Unable to convert the sent event to JSON object")
              return
            }
            XCTAssertNotNil(actualData, "The event data should not be nil")
            expectedData[EventKeys.type] = API.Event.click.description
            XCTAssertTrue(NSDictionary(dictionary: actualData).isEqual(to: expectedData), "Sent event data should be the same as the expected one")
          } catch _ {
            XCTFail("Unable to convert the sent event to JSON")
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
    
    insightsRegister.click(params: expectedData)
    
    waitForExpectations(timeout: 2, handler: nil)
  }
}

//
//  InsightsTests.swift
//  InsightsTests
//
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class TestSearchEventTracker: SearchEventTrackable {
    
    var didClick: ((String, String, String?, Int64, [(String, Int)]) -> Void)?
    var didConvert: ((String, String, String?, Int64, [String]) -> Void)?
    
    func click(queryID: String, indexName: String, userToken: String?, timestamp: Int64, objectIDs: [String], positions: [Int]) {
        let objectIDsWithPositions = zip(objectIDs, positions).map { ($0, $1) }
        didClick?(queryID, indexName, userToken, timestamp, objectIDsWithPositions)
    }
    
    func click(queryID: String, indexName: String, userToken: String?, timestamp: Int64, objectIDsWithPositions: [(String, Int)]) {
        didClick?(queryID, indexName, userToken, timestamp, objectIDsWithPositions)
    }
    
    func conversion(queryID: String, indexName: String, userToken: String?, timestamp: Int64, objectIDs: [String]) {
        didConvert?(queryID, indexName, userToken, timestamp, objectIDs)
    }
    
}

class TestCustomEventTracker: CustomEventTrackable {
    
    var didClickObjects: ((String, String, String?, Int64, [String]) -> Void)?
    var didClickFilters: ((String, String, String?, Int64, [String]) -> Void)?
    var didConvertObjects: ((String, String, String?, Int64, [String]) -> Void)?
    var didConvertFilters: ((String, String, String?, Int64, [String]) -> Void)?
    var didViewObjects: ((String, String, String?, Int64, [String]) -> Void)?
    var didViewFilters: ((String, String, String?, Int64, [String]) -> Void)?

    func click(eventName: String, indexName: String, userToken: String?, timestamp: Int64, filters: [String]) {
        didClickFilters?(eventName, indexName, userToken, timestamp, filters)
    }
    
    func click(eventName: String, indexName: String, userToken: String?, timestamp: Int64, objectIDs: [String]) {
        didClickObjects?(eventName, indexName, userToken, timestamp, objectIDs)
    }
    
    func conversion(eventName: String, indexName: String, userToken: String?, timestamp: Int64, filters: [String]) {
        didConvertFilters?(eventName, indexName, userToken, timestamp, filters)
    }
    
    func conversion(eventName: String, indexName: String, userToken: String?, timestamp: Int64, objectIDs: [String]) {
        didConvertObjects?(eventName, indexName, userToken, timestamp, objectIDs)
    }
    
    func view(eventName: String, indexName: String, userToken: String?, timestamp: Int64, filters: [String]) {
        didViewFilters?(eventName, indexName, userToken, timestamp, filters)
    }
    
    func view(eventName: String, indexName: String, userToken: String?, timestamp: Int64, objectIDs: [String]) {
        didViewObjects?(eventName, indexName, userToken, timestamp, objectIDs)
    }
    
}

class InsightsTests: XCTestCase {
    
    let testCredentials = Credentials(appId: "test app id", apiKey: "test key")
    let searchEventTracker = TestSearchEventTracker()
    let customEventTracker = TestCustomEventTracker()
    let testEventProcessor = TestEventProcessor()
    let testLogger = Logger("test app id")
    lazy var testInsights: Insights = {
        return Insights(eventsProcessor: testEventProcessor,
                        searchEventTracker: searchEventTracker,
                        customEventTracker: customEventTracker,
                        logger: testLogger)
    }()
    
    struct Expected {
        let indexName = "index name"
        let eventName = "event name"
        let userToken = "user token"
        let timestamp = Date().timeIntervalSince1970
        let queryID = "query id"
        let objectIDs = ["o1", "o2"]
        let positions = [1, 2]
        var objectIDsWithPositions: [(String, Int)] {
            return zip(objectIDs, positions).map { ($0, $1) }
        }
        let filters = ["f1", "f2"]
    
    }
    
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
        
        let insightsRegister = Insights.register(appId: testCredentials.appId, apiKey: testCredentials.apiKey)
        XCTAssertNotNil(insightsRegister)
        
        let insightsShared = Insights.shared(appId: testCredentials.appId)
        XCTAssertNotNil(insightsShared)
        
        XCTAssertEqual(insightsRegister, insightsShared, "Getting the Insights instance from register and shared should be the same")
        
    }
    
    func testOptIntOptOut() {
        
        let insightsRegister = Insights.register(appId: testCredentials.appId, apiKey: testCredentials.apiKey)
        
        XCTAssertTrue(insightsRegister.eventsProcessor.isActive)
        insightsRegister.isActive = false
        XCTAssertFalse(insightsRegister.eventsProcessor.isActive)
        
    }
    
    func testClickInSearch() {
        let exp = expectation(description: "callback expectation")
        exp.expectedFulfillmentCount = 2
        let expected = Expected()
        
        searchEventTracker.didClick = { queryID, indexName, userToken, timeStamp, objectIDsWithPositions in
            exp.fulfill()
            XCTAssertEqual(expected.queryID, queryID)
            XCTAssertEqual(expected.userToken, userToken)
            XCTAssertEqual(expected.indexName, indexName)
            XCTAssertEqual(expected.timestamp, TimeInterval(timeStamp/1000), accuracy: 1)
            if objectIDsWithPositions.count > 1 {
                XCTAssertEqual(expected.objectIDsWithPositions.map { $0.0 }, objectIDsWithPositions.map { $0.0 })
                XCTAssertEqual(expected.objectIDsWithPositions.map { $0.1 }, objectIDsWithPositions.map { $0.1 })
            } else {
                XCTAssertEqual(expected.objectIDsWithPositions.first?.0, objectIDsWithPositions.first?.0)
                XCTAssertEqual(expected.objectIDsWithPositions.first?.1, objectIDsWithPositions.first?.1)
            }
        }
        
        testInsights.clickAfterSearch(withQueryID: expected.queryID,
                                      indexName: expected.indexName,
                                      objectID: expected.objectIDs.first!,
                                      position: expected.positions.first!,
                                      userToken: expected.userToken,
                                      timestamp: expected.timestamp)
        
        testInsights.clickAfterSearch(withQueryID: expected.queryID,
                                      indexName: expected.indexName,
                                      objectIDsWithPositions: expected.objectIDsWithPositions,
                                      userToken: expected.userToken,
                                      timestamp: expected.timestamp)
        
        wait(for: [exp], timeout: 5)
    }
    
    func testConversionInSearch() {
        let exp = expectation(description: "callback expectation")
        exp.expectedFulfillmentCount = 2
        let expected = Expected()
        
        searchEventTracker.didConvert = { queryID, indexName, userToken, timeStamp, objectIDs in
            exp.fulfill()
            XCTAssertEqual(expected.queryID, queryID)
            XCTAssertEqual(expected.userToken, userToken)
            XCTAssertEqual(expected.indexName, indexName)
            XCTAssertEqual(expected.timestamp, TimeInterval(timeStamp/1000), accuracy: 1)
            if objectIDs.count > 1 {
                XCTAssertEqual(expected.objectIDs, objectIDs)
            } else {
                XCTAssertEqual(expected.objectIDs.first, objectIDs.first)
            }
        }
        
        testInsights.conversionAfterSearch(withQueryID: expected.queryID,
                                           indexName: expected.indexName,
                                           objectIDs: expected.objectIDs,
                                           userToken: expected.userToken,
                                           timestamp: expected.timestamp)
        
        testInsights.conversionAfterSearch(withQueryID: expected.queryID,
                                           indexName: expected.indexName,
                                           objectID: expected.objectIDs.first!,
                                           userToken: expected.userToken,
                                           timestamp: expected.timestamp)
        
        wait(for: [exp], timeout: 5)

    }
    
    func testClickWithObjects() {
        let exp = expectation(description: "callback expectation")
        exp.expectedFulfillmentCount = 2
        let expected = Expected()
        
        customEventTracker.didClickObjects = { eventName, indexName, userToken, timeStamp, objectIDs in
            exp.fulfill()
            XCTAssertEqual(expected.eventName, eventName)
            XCTAssertEqual(expected.userToken, userToken)
            XCTAssertEqual(expected.indexName, indexName)
            XCTAssertEqual(expected.timestamp, TimeInterval(timeStamp/1000), accuracy: 1)
            if objectIDs.count > 1 {
                XCTAssertEqual(expected.objectIDs, objectIDs)
            } else {
                XCTAssertEqual(expected.objectIDs.first, objectIDs.first)
            }
        }
        
        testInsights.click(eventName: expected.eventName,
                           indexName: expected.indexName,
                           objectIDs: expected.objectIDs,
                           userToken: expected.userToken,
                           timestamp: expected.timestamp)
        
        testInsights.click(eventName: expected.eventName,
                           indexName: expected.indexName,
                           objectID: expected.objectIDs.first!,
                           userToken: expected.userToken,
                           timestamp: expected.timestamp)
        
        wait(for: [exp], timeout: 5)

    }
    
    func testClickWithFilters() {
        let exp = expectation(description: "callback expectation")
        let expected = Expected()
        
        customEventTracker.didClickFilters = { eventName, indexName, userToken, timeStamp, filters in
            exp.fulfill()
            XCTAssertEqual(expected.eventName, eventName)
            XCTAssertEqual(expected.userToken, userToken)
            XCTAssertEqual(expected.indexName, indexName)
            XCTAssertEqual(expected.timestamp, TimeInterval(timeStamp/1000), accuracy: 1)
            XCTAssertEqual(expected.filters, filters)
        }
        
        testInsights.click(eventName: expected.eventName,
                           indexName: expected.indexName,
                           filters: expected.filters,
                           userToken: expected.userToken,
                           timestamp: expected.timestamp)
        
        wait(for: [exp], timeout: 5)
        
    }
    
    func testConversionWithObjects() {
        let exp = expectation(description: "callback expectation")
        exp.expectedFulfillmentCount = 2
        let expected = Expected()
        
        customEventTracker.didConvertObjects = { eventName, indexName, userToken, timeStamp, objectIDs in
            exp.fulfill()
            XCTAssertEqual(expected.eventName, eventName)
            XCTAssertEqual(expected.userToken, userToken)
            XCTAssertEqual(expected.indexName, indexName)
            XCTAssertEqual(expected.timestamp, TimeInterval(timeStamp/1000), accuracy: 1)
            if objectIDs.count > 1 {
                XCTAssertEqual(expected.objectIDs, objectIDs)
            } else {
                XCTAssertEqual(expected.objectIDs.first, objectIDs.first)
            }
        }
        
        testInsights.conversion(eventName: expected.eventName,
                                indexName: expected.indexName,
                                objectIDs: expected.objectIDs,
                                userToken: expected.userToken,
                                timestamp: expected.timestamp)
        
        testInsights.conversion(eventName: expected.eventName,
                                indexName: expected.indexName,
                                objectID: expected.objectIDs.first!,
                                userToken: expected.userToken,
                                timestamp: expected.timestamp)
        
        wait(for: [exp], timeout: 5)
    }
    
    func testConversionWithFilters() {
        let exp = expectation(description: "callback expectation")
        let expected = Expected()
        
        customEventTracker.didConvertFilters = { eventName, indexName, userToken, timeStamp, filters in
            exp.fulfill()
            XCTAssertEqual(expected.eventName, eventName)
            XCTAssertEqual(expected.userToken, userToken)
            XCTAssertEqual(expected.indexName, indexName)
            XCTAssertEqual(expected.timestamp, TimeInterval(timeStamp/1000), accuracy: 1)
            XCTAssertEqual(expected.filters, filters)
        }

        
        testInsights.conversion(eventName: expected.eventName,
                                indexName: expected.indexName,
                                filters: expected.filters,
                                userToken: expected.userToken,
                                timestamp: expected.timestamp)
        
        wait(for: [exp], timeout: 5)
    }
    
    func testViewWithObjects() {
        let exp = expectation(description: "callback expectation")
        exp.expectedFulfillmentCount = 2
        let expected = Expected()
        
        customEventTracker.didViewObjects = { eventName, indexName, userToken, timeStamp, objectIDs in
            exp.fulfill()
            XCTAssertEqual(expected.eventName, eventName)
            XCTAssertEqual(expected.userToken, userToken)
            XCTAssertEqual(expected.indexName, indexName)
            XCTAssertEqual(expected.timestamp, TimeInterval(timeStamp/1000), accuracy: 1)
            if objectIDs.count > 1 {
                XCTAssertEqual(expected.objectIDs, objectIDs)
            } else {
                XCTAssertEqual(expected.objectIDs.first, objectIDs.first)
            }
        }
        
        testInsights.view(eventName: expected.eventName,
                          indexName: expected.indexName,
                          objectIDs: expected.objectIDs,
                          userToken: expected.userToken,
                          timestamp: expected.timestamp)
        
        testInsights.view(eventName: expected.eventName,
                          indexName: expected.indexName,
                          objectID: expected.objectIDs.first!,
                          userToken: expected.userToken,
                          timestamp: expected.timestamp)
        
        wait(for: [exp], timeout: 5)
    }
    
    func testViewWithFilters() {
        let exp = expectation(description: "callback expectation")
        let expected = Expected()
        
        customEventTracker.didViewFilters = { eventName, indexName, userToken, timeStamp, filters in
            exp.fulfill()
            XCTAssertEqual(expected.eventName, eventName)
            XCTAssertEqual(expected.userToken, userToken)
            XCTAssertEqual(expected.indexName, indexName)
            XCTAssertEqual(expected.timestamp, TimeInterval(timeStamp/1000), accuracy: 1)
            XCTAssertEqual(expected.filters, filters)
        }
        
        testInsights.view(eventName: expected.eventName,
                          indexName: expected.indexName,
                          filters: expected.filters,
                          userToken: expected.userToken,
                          timestamp: expected.timestamp)
        
        wait(for: [exp], timeout: 5)
    }

    func testEventIsSentCorrectly() {
        
        let exp = self.expectation(description: "wait mock web service")
        let expected = Expected()
        
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
                exp.fulfill()
            } else {
                XCTFail("Unable to cast resource")
            }
        }
        
        let insightsRegister = Insights(credentials: Credentials(appId: testCredentials.appId,
                                                                 apiKey: testCredentials.apiKey),
                                        webService: mockWS,
                                        flushDelay: 1,
                                        logger: Logger(testCredentials.appId))
     
        insightsRegister.clickAfterSearch(withQueryID: expected.queryID,
                                          indexName: expected.indexName,
                                          objectIDsWithPositions: expected.objectIDsWithPositions,
                                          userToken: expected.userToken)
        
        wait(for: [exp], timeout: 5)
    }
    
    func testGlobalAppUserTokenPropagation() {
        
        let exp = expectation(description: "process event expectation")
        
        let expectedIndexName = "test index name"
        let expectedQueryID = "6de2f7eaa537fa93d8f8f05b927953b1"
        let expectedObjectIDsWithPositions = [("o1", 1)]

        
        let eventProcessor = TestEventProcessor()
        
        eventProcessor.didProcess = { event in
            XCTAssertEqual(Insights.userToken, event.userToken)
            exp.fulfill()
        }
        
        let logger = Logger(testCredentials.appId)
        
        let insights = Insights(eventsProcessor: eventProcessor, logger: logger)
        
        insights.clickAfterSearch(withQueryID: expectedQueryID,
                                  indexName: expectedIndexName,
                                  objectID: expectedObjectIDsWithPositions.first!.0,
                                  position: expectedObjectIDsWithPositions.first!.1)
        
        wait(for: [exp], timeout: 5)
        
    }
    
    func testPerAppUserTokenPropagation() {
        
        let exp = expectation(description: "process event expectation")
        
        let expectedIndexName = "test index name"
        let expectedUserToken = "test user token"
        let expectedQueryID = "6de2f7eaa537fa93d8f8f05b927953b1"
        let expectedObjectIDsWithPositions = [("o1", 1)]
        
        
        let eventProcessor = TestEventProcessor()
        
        eventProcessor.didProcess = { event in
            XCTAssertEqual(expectedUserToken, event.userToken)
            exp.fulfill()
        }
        
        let logger = Logger(testCredentials.appId)
        
        let insights = Insights(eventsProcessor: eventProcessor, userToken: expectedUserToken, logger: logger)
        
        insights.clickAfterSearch(withQueryID: expectedQueryID,
                                  indexName: expectedIndexName,
                                  objectID: expectedObjectIDsWithPositions.first!.0,
                                  position: expectedObjectIDsWithPositions.first!.1)
        
        wait(for: [exp], timeout: 5)

    }
    
}

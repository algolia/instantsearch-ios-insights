//
//  ViewTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class ViewTests: XCTestCase {
    
    func testViewEncoding() {
        
        let expectedEventType = EventType.view
        let expectedEventName = "test name"
        let expectedIndexName = "test index"
        let expectedUserToken = "test token"
        let expectedQueryID = "test query id"
        let expectedTimeStamp = Date().timeIntervalSince1970
        let expectedFilter =  Filter(rawValue: "brand:apple")!
        let expectedWrappedFilter = ObjectsIDsOrFilters.filters([expectedFilter])
        
        let event = try! View(name: expectedEventName,
                              index: expectedIndexName,
                              userToken: expectedUserToken,
                              timestamp: expectedTimeStamp,
                              queryID: expectedQueryID,
                              objectIDsOrFilters: expectedWrappedFilter)
        
        let eventDictionary = Dictionary(event)!
        
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.type.rawValue] as? String, expectedEventType.rawValue)
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.name.rawValue] as? String, expectedEventName)
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.indexName.rawValue] as? String, expectedIndexName)
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.userToken.rawValue] as? String, expectedUserToken)
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.timestamp.rawValue] as? TimeInterval, expectedTimeStamp)
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.queryID.rawValue] as? String, expectedQueryID)
        XCTAssertEqual(eventDictionary[ObjectsIDsOrFilters.CodingKeys.filters.rawValue] as? [String], [expectedFilter.rawValue])
        
    }
    
    func testViewDecoding() {
        
        let expectedEventType = EventType.view
        let expectedEventName = "test name"
        let expectedIndexName = "test index"
        let expectedUserToken = "test token"
        let expectedQueryID = "test query id"
        let expectedTimeStamp = Date().timeIntervalSince1970
        let expectedFilter =  Filter(rawValue: "brand:apple")!
        let expectedWrappedFilter = ObjectsIDsOrFilters.filters([expectedFilter])
        
        let eventDictionary: [String: Any] = [
            CoreEvent.CodingKeys.type.rawValue: expectedEventType.rawValue,
            CoreEvent.CodingKeys.name.rawValue: expectedEventName,
            CoreEvent.CodingKeys.indexName.rawValue: expectedIndexName,
            CoreEvent.CodingKeys.userToken.rawValue: expectedUserToken,
            CoreEvent.CodingKeys.queryID.rawValue: expectedQueryID,
            CoreEvent.CodingKeys.timestamp.rawValue: expectedTimeStamp,
            ObjectsIDsOrFilters.CodingKeys.filters.rawValue: [expectedFilter.rawValue],
            ]
        
        let data = try! JSONSerialization.data(withJSONObject: eventDictionary, options: [])
        
        let jsonDecoder = JSONDecoder()
        
        do {
            let event = try jsonDecoder.decode(View.self, from: data)
            
            XCTAssertEqual(event.type, expectedEventType)
            XCTAssertEqual(event.name, expectedEventName)
            XCTAssertEqual(event.indexName, expectedIndexName)
            XCTAssertEqual(event.userToken, expectedUserToken)
            XCTAssertEqual(event.queryID, expectedQueryID)
            XCTAssertEqual(event.timestamp, expectedTimeStamp)
            XCTAssertEqual(event.objectIDsOrFilters, expectedWrappedFilter)
            
        } catch let error {
            XCTFail("\(error)")
        }
        
    }
    
}

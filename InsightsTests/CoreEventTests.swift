//
//  CoreEventTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class CoreEventTests: XCTestCase {

    func testEventEncoding() {
        
        let filter = Filter(rawValue: "category:toys")!
        let event = try! CoreEvent(type: .click, name: "Test event name", index: "Test index name", userToken: "Test user token", queryID: "Test query id", objectIDsOrFilters: .filters([filter]))
        
        let eventDictionary = try! event.asDictionary()
        
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.type.rawValue] as? String, EventType.click.rawValue)
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.name.rawValue] as? String, "Test event name")
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.index.rawValue] as? String, "Test index name")
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.userToken.rawValue] as? String, "Test user token")
        XCTAssertEqual(eventDictionary[CoreEvent.CodingKeys.queryID.rawValue] as? String, "Test query id")
        
    }
    
    func testEventDecoding() {
        
        let expectedEventType = EventType.click
        let expectedEventName = "Test event name"
        let expectedIndexName = "Test index name"
        let expectedUserToken = "Test user token"
        let expectedQueryID = "Test query id"
        let expectedTimeStamp = Date().timeIntervalSince1970
        let expectedFilter =  Filter(rawValue: "brand:apple")!
        let expectedWrappedFilter = ObjectsIDsOrFilters.filters([expectedFilter])
        
        let eventDictionary: [String: Any] = [
            CoreEvent.CodingKeys.type.rawValue: expectedEventType.rawValue,
            CoreEvent.CodingKeys.name.rawValue: expectedEventName,
            CoreEvent.CodingKeys.index.rawValue: expectedIndexName,
            CoreEvent.CodingKeys.userToken.rawValue: expectedUserToken,
            CoreEvent.CodingKeys.queryID.rawValue: expectedQueryID,
            CoreEvent.CodingKeys.timestamp.rawValue: expectedTimeStamp,
            ObjectsIDsOrFilters.CodingKeys.filters.rawValue: [expectedFilter.rawValue],
            ]
        
        let data = try! JSONSerialization.data(withJSONObject: eventDictionary, options: [])
        
        let jsonDecoder = JSONDecoder()
        
        do {
            let event = try jsonDecoder.decode(CoreEvent.self, from: data)
            
            XCTAssertEqual(event.type, expectedEventType)
            XCTAssertEqual(event.name, expectedEventName)
            XCTAssertEqual(event.index, expectedIndexName)
            XCTAssertEqual(event.userToken, expectedUserToken)
            XCTAssertEqual(event.queryID, expectedQueryID)
            XCTAssertEqual(event.timestamp, expectedTimeStamp)
            XCTAssertEqual(event.objectIDsOrFilters, expectedWrappedFilter)
            
        } catch let error {
            XCTFail("\(error)")
        }
        
    }
    
}

//
//  EventsPackageTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class EventsPackageTests: XCTestCase {
    
    func testEventsPackageEncoding() {
        
        let expectedIndexName = "test index"
        let expectedUserToken = "test token"
        let expectedQueryID = "test query id"
        let expectedTimeStamp = Date().timeIntervalSince1970
        let expectedFilter =  Filter(rawValue: "brand:apple")!
        let expectedWrappedFilter = ObjectsIDsOrFilters.filters([expectedFilter])
        
        let event1 = try! Conversion(name: "test conversion event", index: expectedIndexName, userToken: expectedUserToken, timestamp: expectedTimeStamp, queryID: expectedQueryID, objectIDsOrFilters: expectedWrappedFilter)
        let event2 = try! View(name: "test view event", index: expectedIndexName, userToken: expectedUserToken, timestamp: expectedTimeStamp, queryID: expectedQueryID, objectIDsOrFilters: expectedWrappedFilter)
        
        do {
            let package = try EventsPackage(events: [.conversion(event1), .view(event2)])
            let dictionary = try package.asDictionary()
            
            guard let events = dictionary["events"] as? [[String: Any]], events.count == 2 else {
                XCTFail("Incorrect events count in package")
                return
            }
            
        } catch let error {
            XCTFail("\(error)")
        }
        
    }
    
    func testEventsPackageDecoding() {
        
        let expectedIndexName = "test index"
        let expectedUserToken = "test token"
        let expectedQueryID = "test query id"
        let expectedTimeStamp = Date().timeIntervalSince1970
        let expectedFilter =  Filter(rawValue: "brand:apple")!
        
        let eventDictionary1: [String: Any] = [
            CoreEvent.CodingKeys.type.rawValue: EventType.conversion.rawValue,
            CoreEvent.CodingKeys.name.rawValue: "test conversion event",
            CoreEvent.CodingKeys.index.rawValue: expectedIndexName,
            CoreEvent.CodingKeys.userToken.rawValue: expectedUserToken,
            CoreEvent.CodingKeys.queryID.rawValue: expectedQueryID,
            CoreEvent.CodingKeys.timestamp.rawValue: expectedTimeStamp,
            ObjectsIDsOrFilters.CodingKeys.filters.rawValue: [expectedFilter.rawValue],
            ]
        
        let eventDictionary2: [String: Any] = [
            CoreEvent.CodingKeys.type.rawValue: EventType.view.rawValue,
            CoreEvent.CodingKeys.name.rawValue: "test view event",
            CoreEvent.CodingKeys.index.rawValue: expectedIndexName,
            CoreEvent.CodingKeys.userToken.rawValue: expectedUserToken,
            CoreEvent.CodingKeys.queryID.rawValue: expectedQueryID,
            CoreEvent.CodingKeys.timestamp.rawValue: expectedTimeStamp,
            ObjectsIDsOrFilters.CodingKeys.filters.rawValue: [expectedFilter.rawValue],
            ]
        
        let packageDictionary: [String: Any] = [
            "id": "test package id",
            "events": [eventDictionary1, eventDictionary2],
            ]
        
        let data = try! JSONSerialization.data(withJSONObject: packageDictionary, options: [])
        
        do {
            let decoder = JSONDecoder()
            let package = try decoder.decode(EventsPackage.self, from: data)
            XCTAssertEqual(package.id, "test package id")
            XCTAssertEqual(package.events.count, 2)
            
        } catch let error {
            XCTFail("\(error)")
        }
        
    }
    
}

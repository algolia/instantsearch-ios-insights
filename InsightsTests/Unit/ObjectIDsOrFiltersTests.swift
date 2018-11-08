//
//  ObjectIDsOrFiltersTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 08/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class ObjectIDsOrFiltersTests: XCTestCase {
    
    func testEncoding() {
        
    }
    
    func testDecoding() {
        
    }
    
    func testFailedDecoding() {
        
        let data = try! JSONSerialization.data(withJSONObject: ["a": "b"], options: [])
        
        let jsonDecoder = JSONDecoder()
        
        do {
            _ = try jsonDecoder.decode(ObjectsIDsOrFilters.self, from: data)
        } catch let error {
            XCTAssertEqual(error as? ObjectsIDsOrFilters.Error, ObjectsIDsOrFilters.Error.decodingFailure)
            XCTAssertEqual(error.localizedDescription, "Neither \(ObjectsIDsOrFilters.CodingKeys.filters.rawValue), nor \(ObjectsIDsOrFilters.CodingKeys.objectIDs.rawValue) key found on decoder"
)
        }
        
    }
    
}

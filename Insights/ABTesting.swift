//
//  ABTesting.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

@objcMembers public class ABTesting: AnalyticsUsecase {
    
    let indexName: String
    weak var eventProcessor: EventProcessor?
    
    init(indexName: String) {
        self.indexName = indexName
    }
    
    func click(userToken: String,
               timestamp: TimeInterval = Date().timeIntervalSince1970,
               queryID: String,
        objectIDsWithPositions: [(String, Int)]) throws {
        let event = try Click(name: "",
                              index: indexName,
                              userToken: userToken,
                              timestamp: timestamp,
                              queryID: queryID,
                              objectIDsWithPositions: objectIDsWithPositions)
        eventProcessor?.process(event)
    }
    
    func conversion(userToken: String,
                    timestamp: TimeInterval = Date().timeIntervalSince1970,
                    queryID: String,
                    objectIDs: [String]) throws {
        let event = try Conversion(name: "",
                                   index: indexName,
                                   userToken: userToken,
                                   timestamp: timestamp,
                                   queryID: queryID,
                                   objectIDsOrFilters: .objectIDs(objectIDs))
        eventProcessor?.process(event)
    }
    
}

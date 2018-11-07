//
//  ABTesting.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

@objcMembers public class ABTesting: AnalyticsUsecase {
    
    var eventProcessor: EventProcessor
    
    init(eventProcessor: EventProcessor) {
        self.eventProcessor = eventProcessor
    }
    
    func click(index: String,
               userToken: String,
               timestamp: TimeInterval = Date().timeIntervalSince1970,
               queryID: String,
        objectIDsWithPositions: [(String, Int)]) throws {
        let event = try Click(name: "",
                              index: index,
                              userToken: userToken,
                              timestamp: timestamp,
                              queryID: queryID,
                              objectIDsWithPositions: objectIDsWithPositions)
        eventProcessor.process(event)
    }
    
    func conversion(index: String,
                    userToken: String,
                    timestamp: TimeInterval = Date().timeIntervalSince1970,
                    queryID: String,
                    objectIDs: [String]) throws {
        let event = try Conversion(name: "", index: index, userToken: userToken, timestamp: timestamp, queryID: queryID, objectIDsOrFilters: .objectIDs(objectIDs))
        eventProcessor.process(event)
    }
    
}

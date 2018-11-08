//
//  ClickAnalytics.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

@objcMembers public class ClickAnalytics: NSObject, AnalyticsUsecase {
    
    var eventProcessor: EventProcessor
    
    init(eventProcessor: EventProcessor) {
        self.eventProcessor = eventProcessor
    }
    
    @available(swift, obsoleted: 3.1)
    public func click(userToken: String,
                      indexName: String,
                      timestamp: TimeInterval = Date().timeIntervalSince1970,
                      queryID: String,
                      objectIDs: [String],
                      positions: [Int]) throws {
        let objectIDsWithPositions = zip(objectIDs, positions).map { $0 }
        try click(userToken: userToken,
                  indexName: indexName,
                  queryID: queryID,
                  objectIDsWithPositions: objectIDsWithPositions)
    }
    
    public func click(userToken: String,
                      indexName: String,
                      timestamp: TimeInterval = Date().timeIntervalSince1970,
                      queryID: String,
                      objectIDsWithPositions: [(String, Int)]) throws {
        let event = try Click(name: "",
                              indexName: indexName,
                              userToken: userToken,
                              timestamp: timestamp,
                              queryID: queryID,
                              objectIDsWithPositions: objectIDsWithPositions)
        eventProcessor.process(event)
    }
    
    public func conversion(userToken: String,
                           indexName: String,
                           timestamp: TimeInterval = Date().timeIntervalSince1970,
                           queryID: String,
                           objectIDs: [String]) throws {
        let event = try Conversion(name: "",
                                   indexName: indexName,
                                   userToken: userToken,
                                   timestamp: timestamp,
                                   queryID: queryID,
                                   objectIDsOrFilters: .objectIDs(objectIDs))
        eventProcessor.process(event)
    }
    
}

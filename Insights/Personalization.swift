//
//  Personalization.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

@objcMembers public class Personalization: NSObject, AnalyticsUsecase {
    
    var eventProcessor: EventProcessor
    
    init(eventProcessor: EventProcessor) {
        self.eventProcessor = eventProcessor
    }
    
    public func view(eventName: String,
                     indexName: String,
                     userToken: String,
                     timestamp: TimeInterval = Date().timeIntervalSince1970,
                     objectIDs: [String]) throws {
        let event = try View(name: eventName,
                             indexName: indexName,
                             userToken: userToken,
                             timestamp: timestamp,
                             queryID: .none,
                             objectIDsOrFilters: .objectIDs(objectIDs))
        eventProcessor.process(event)
    }
    
    public func view(eventName: String,
                     indexName: String,
                     userToken: String,
                     timestamp: TimeInterval = Date().timeIntervalSince1970,
                     filters: [String]) throws {
        let event = try View(name: eventName,
                             indexName: indexName,
                             userToken: userToken,
                             timestamp: timestamp,
                             queryID: .none,
                             objectIDsOrFilters: .filters(filters))
        eventProcessor.process(event)
    }
    
    public func click(eventName: String,
                      indexName: String,
                      userToken: String,
                      timestamp: TimeInterval = Date().timeIntervalSince1970,
                      objectIDs: [String]) throws {
        let event = try Click(name: eventName,
                              indexName: indexName,
                              userToken: userToken,
                              timestamp: timestamp,
                              objectIDsOrFilters: .objectIDs(objectIDs),
                              positions: .none)
        eventProcessor.process(event)
    }
    
    public func click(eventName: String,
                      indexName: String,
                      userToken: String,
                      timestamp: TimeInterval = Date().timeIntervalSince1970,
                      filters: [String]) throws {
        let event = try Click(name: eventName,
                              indexName: indexName,
                              userToken: userToken,
                              timestamp: timestamp,
                              objectIDsOrFilters: .filters(filters),
                              positions: .none)
        eventProcessor.process(event)
    }
    
    public func conversion(eventName: String,
                           indexName: String,
                           userToken: String,
                    	timestamp: TimeInterval,
                        objectIDs: [String]) throws {
        let event = try Conversion(name: eventName,
                                   indexName: indexName,
                                   userToken: userToken,
                                   timestamp: timestamp,
                                   queryID: .none,
                                   objectIDsOrFilters: .objectIDs(objectIDs))
        eventProcessor.process(event)
    }
    
    public func conversion(eventName: String,
                           indexName: String,
                           userToken: String,
                           timestamp: TimeInterval,
                           filters: [String]) throws {
        let event = try Conversion(name: eventName,
                                   indexName: indexName,
                                   userToken: userToken,
                                   timestamp: timestamp,
                                   queryID: .none,
                                   objectIDsOrFilters: .filters(filters))
        eventProcessor.process(event)
    }

}

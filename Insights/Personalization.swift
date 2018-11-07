//
//  Personalization.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

@objcMembers public class Personalization: AnalyticsUsecase {
    
    let indexName: String
    weak var eventProcessor: EventProcessor?
    
    init(indexName: String) {
        self.indexName = indexName
    }
    
    func view(eventName: String,
              userToken: String,
              timestamp: TimeInterval = Date().timeIntervalSince1970,
              objectIDs: [String]) throws {
        let event = try View(name: eventName,
                             index: indexName,
                             userToken: userToken,
                             timestamp: timestamp,
                             queryID: .none,
                             objectIDsOrFilters: .objectIDs(objectIDs))
        eventProcessor?.process(event)
    }
    
    func view(eventName: String,
              userToken: String,
              timestamp: TimeInterval = Date().timeIntervalSince1970,
              filters: [Filter]) throws {
        let event = try View(name: eventName,
                             index: indexName,
                             userToken: userToken,
                             timestamp: timestamp,
                             queryID: .none,
                             objectIDsOrFilters: .filters(filters))
        eventProcessor?.process(event)
    }
    
    func click(eventName: String,
               userToken: String,
               timestamp: TimeInterval = Date().timeIntervalSince1970,
               objectIDs: [String]) throws {
        let event = try Click(name: eventName,
                              index: indexName,
                              userToken: userToken,
                              timestamp: timestamp,
                              objectIDsOrFilters: .objectIDs(objectIDs),
                              positions: .none)
        eventProcessor?.process(event)
    }
    
    func click(eventName: String,
               userToken: String,
               timestamp: TimeInterval = Date().timeIntervalSince1970,
               filters: [Filter]) throws {
        let event = try Click(name: eventName,
                              index: indexName,
                              userToken: userToken,
                              timestamp: timestamp,
                              objectIDsOrFilters: .filters(filters),
                              positions: .none)
        eventProcessor?.process(event)
    }
    
    func conversion(eventName: String,
                    userToken: String,
                    timestamp: TimeInterval,
                    objectIDs: [String]) throws {
        let event = try Conversion(name: eventName,
                                   index: indexName,
                                   userToken: userToken,
                                   timestamp: timestamp,
                                   queryID: .none,
                                   objectIDsOrFilters: .objectIDs(objectIDs))
        eventProcessor?.process(event)
    }
    
    func conversion(eventName: String,
                    userToken: String,
                    timestamp: TimeInterval,
                    filters: [Filter]) throws {
        let event = try Conversion(name: eventName,
                                   index: indexName,
                                   userToken: userToken,
                                   timestamp: timestamp,
                                   queryID: .none,
                                   objectIDsOrFilters: .filters(filters))
        eventProcessor?.process(event)
    }

}

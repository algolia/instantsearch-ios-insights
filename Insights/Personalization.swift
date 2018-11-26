//
//  Personalization.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

/**
 Personalization feature introduces user-based relevance,
 an additional layer on top of Algolia’s relevance strategy
 by injecting user preferences into the relevance formula.
 Personalization relies on the event capturing mechanism, which allows you
 to track events that will eventually form the basis of every profile.
*/

@objcMembers public class Personalization: NSObject, AnalyticsUsecase {
    
    var eventProcessor: EventProcessor
    var logger: Logger
    
    init(eventProcessor: EventProcessor, logger: Logger) {
        self.eventProcessor = eventProcessor
        self.logger = logger
    }
    
    /// Track a view
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter userToken: User identifier
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    
    public func view(eventName: String,
                     indexName: String,
                     userToken: String,
                     timestamp: TimeInterval = Date().timeIntervalSince1970,
                     objectIDs: [String]) {
        do {
            
            let event = try View(name: eventName,
                                 indexName: indexName,
                                 userToken: userToken,
                                 timestamp: timestamp,
                                 queryID: .none,
                                 objectIDsOrFilters: .objectIDs(objectIDs))
            eventProcessor.process(event)
        
        } catch let error {
            logger.debug(message: error.localizedDescription)
        }
    }
    
    /// Track a view
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter userToken: User identifier
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter filters: An array of filters. Limited to 10 filters.
    
    public func view(eventName: String,
                     indexName: String,
                     userToken: String,
                     timestamp: TimeInterval = Date().timeIntervalSince1970,
                     filters: [String]) {
        do {

            let event = try View(name: eventName,
                                 indexName: indexName,
                                 userToken: userToken,
                                 timestamp: timestamp,
                                 queryID: .none,
                                 objectIDsOrFilters: .filters(filters))
            eventProcessor.process(event)

        } catch let error {
            logger.debug(message: error.localizedDescription)
        }
    }
    
    /// Track a click
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter userToken: User identifier
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    
    public func click(eventName: String,
                      indexName: String,
                      userToken: String,
                      timestamp: TimeInterval = Date().timeIntervalSince1970,
                      objectIDs: [String]) {
        do {
            
            let event = try Click(name: eventName,
                                  indexName: indexName,
                                  userToken: userToken,
                                  timestamp: timestamp,
                                  objectIDsOrFilters: .objectIDs(objectIDs),
                                  positions: .none)
            eventProcessor.process(event)
            
        } catch let error {
            logger.debug(message: error.localizedDescription)
        }

    }
    
    /// Track a click
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter userToken: User identifier
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter filters: An array of filters. Limited to 10 filters.
    
    public func click(eventName: String,
                      indexName: String,
                      userToken: String,
                      timestamp: TimeInterval = Date().timeIntervalSince1970,
                      filters: [String]) {
        do {
            
            let event = try Click(name: eventName,
                                  indexName: indexName,
                                  userToken: userToken,
                                  timestamp: timestamp,
                                  objectIDsOrFilters: .filters(filters),
                                  positions: .none)
            eventProcessor.process(event)

        } catch let error {
            logger.debug(message: error.localizedDescription)
        }
        
    }
    
    /// Track a conversion
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter userToken: User identifier
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    
    public func conversion(eventName: String,
                           indexName: String,
                           userToken: String,
                    	timestamp: TimeInterval,
                        objectIDs: [String]) {
        do {
            
            let event = try Conversion(name: eventName,
                                       indexName: indexName,
                                       userToken: userToken,
                                       timestamp: timestamp,
                                       queryID: .none,
                                       objectIDsOrFilters: .objectIDs(objectIDs))
            eventProcessor.process(event)

        } catch let error {
            logger.debug(message: error.localizedDescription)
        }
    }
    
    /// Track a conversion
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter userToken: User identifier
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter filters: An array of filters. Limited to 10 filters.
    
    public func conversion(eventName: String,
                           indexName: String,
                           userToken: String,
                           timestamp: TimeInterval,
                           filters: [String]) {
        do {
            
            let event = try Conversion(name: eventName,
                                       indexName: indexName,
                                       userToken: userToken,
                                       timestamp: timestamp,
                                       queryID: .none,
                                       objectIDsOrFilters: .filters(filters))
            eventProcessor.process(event)
            
        } catch let error {
            logger.debug(message: error.localizedDescription)
        }
    }

}

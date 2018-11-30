//
//  Visit.swift
//  Insights
//
//  Created by Vladislav Fitc on 26/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

/// Provides convenient functions for tracking events which can be used for search personalization.
///

@objcMembers public class Visit: NSObject, AnalyticsUsecase {

    var eventProcessor: EventProcessable
    var logger: Logger
    var userToken: String?
    
    init(eventProcessor: EventProcessable,
         logger: Logger,
         userToken: String? = .none) {
        self.eventProcessor = eventProcessor
        self.logger = logger
        self.userToken = userToken
    }
    
    /// Track a view
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    
    public func view(eventName: String,
                     indexName: String,
                     userToken: String? = .none,
                     timestamp: Int64 = Date().millisecondsSince1970,
                     objectIDs: [String]) {
        do {
            
            let event = try View(name: eventName,
                                 indexName: indexName,
                                 userToken: effectiveUserToken(withEventUserToken: userToken),
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
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectID: Index objectID.
    
    public func view(eventName: String,
                     indexName: String,
                     userToken: String? = .none,
                     timestamp: Int64 = Date().millisecondsSince1970,
                     objectID: String) {
        view(eventName: eventName,
             indexName: indexName,
             userToken: effectiveUserToken(withEventUserToken: userToken),
             timestamp: timestamp,
             objectIDs: [objectID])
    }
    
    /// Track a view
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter filters: An array of filters. Limited to 10 filters.
    
    public func view(eventName: String,
                     indexName: String,
                     userToken: String? = .none,
                     timestamp: Int64 = Date().millisecondsSince1970,
                     filters: [String]) {
        do {
            
            let event = try View(name: eventName,
                                 indexName: indexName,
                                 userToken: effectiveUserToken(withEventUserToken: userToken),
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
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    
    public func click(eventName: String,
                      indexName: String,
                      userToken: String? = .none,
                      timestamp: Int64 = Date().millisecondsSince1970,
                      objectIDs: [String]) {
        do {
            
            let event = try Click(name: eventName,
                                  indexName: indexName,
                                  userToken: effectiveUserToken(withEventUserToken: userToken),
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
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectID: Index objectID.
    
    public func click(eventName: String,
                      indexName: String,
                      userToken: String? = .none,
                      timestamp: Int64 = Date().millisecondsSince1970,
                      objectID: String) {
        click(eventName: eventName,
              indexName: indexName,
              userToken: effectiveUserToken(withEventUserToken: userToken),
              timestamp: timestamp,
              objectIDs: [objectID])
    }
    
    /// Track a click
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter filters: An array of filters. Limited to 10 filters.
    
    public func click(eventName: String,
                      indexName: String,
                      userToken: String? = .none,
                      timestamp: Int64 = Date().millisecondsSince1970,
                      filters: [String]) {
        do {
            
            let event = try Click(name: eventName,
                                  indexName: indexName,
                                  userToken: effectiveUserToken(withEventUserToken: userToken),
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
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    
    public func conversion(eventName: String,
                           indexName: String,
                           userToken: String? = .none,
                           timestamp: Int64 = Date().millisecondsSince1970,
                           objectIDs: [String]) {
        do {
            
            let event = try Conversion(name: eventName,
                                       indexName: indexName,
                                       userToken: effectiveUserToken(withEventUserToken: userToken),
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
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectID: Index objectID.
    
    public func conversion(eventName: String,
                           indexName: String,
                           userToken: String? = .none,
                           timestamp: Int64 = Date().millisecondsSince1970,
                           objectID: String) {
        conversion(eventName: eventName,
                   indexName: indexName,
                   userToken: effectiveUserToken(withEventUserToken: userToken),
                   timestamp: timestamp,
                   objectIDs: [objectID])
    }
    
    /// Track a conversion
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter filters: An array of filters. Limited to 10 filters.
    
    public func conversion(eventName: String,
                           indexName: String,
                           userToken: String? = .none,
                           timestamp: Int64 = Date().millisecondsSince1970,
                           filters: [String]) {
        do {
            
            let event = try Conversion(name: eventName,
                                       indexName: indexName,
                                       userToken: effectiveUserToken(withEventUserToken: userToken),
                                       timestamp: timestamp,
                                       queryID: .none,
                                       objectIDsOrFilters: .filters(filters))
            eventProcessor.process(event)
            
        } catch let error {
            logger.debug(message: error.localizedDescription)
        }
    }
    
}

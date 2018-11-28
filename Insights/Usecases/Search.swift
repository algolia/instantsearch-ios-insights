//
//  Search.swift
//  Insights
//
//  Created by Vladislav Fitc on 26/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

/// Provides convenient functions for tracking search-related events
///

@objcMembers public class Search: NSObject, AnalyticsUsecase {
    
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
    
    /// Track a click
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter queryID: Algolia queryID
    /// - parameter objectIDsWithPositions: An array of related index objectID and position of the click in the list of Algolia search results. - Warning: Limited to 20 objects.
    
    public func click(userToken: String? = .none,
                      indexName: String,
                      timestamp: TimeInterval = Date().timeIntervalSince1970,
                      queryID: String,
                      objectIDsWithPositions: [(String, Int)]) {
        do {
            
            let event = try Click(name: "",
                                  indexName: indexName,
                                  userToken: effectiveUserToken(withEventUserToken: userToken),
                                  timestamp: timestamp,
                                  queryID: queryID,
                                  objectIDsWithPositions: objectIDsWithPositions)
            eventProcessor.process(event)
            
        } catch let error {
            logger.debug(message: error.localizedDescription)
        }
    }
    
    /// Track a click
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter queryID: Algolia queryID
    /// - parameter objectID: Index objectID
    /// - parameter position: Position of the click in the list of Algolia search results
    
    public func click(userToken: String? = .none,
                      indexName: String,
                      timestamp: TimeInterval = Date().timeIntervalSince1970,
                      queryID: String,
                      objectID: String,
                      position: Int) {
        click(userToken: effectiveUserToken(withEventUserToken: userToken),
              indexName: indexName,
              queryID: queryID,
              objectIDsWithPositions: [(objectID, position)])
    }
    
    /// Track a conversion
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter queryID: Algolia queryID
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    
    public func conversion(userToken: String? = .none,
                           indexName: String,
                           timestamp: TimeInterval = Date().timeIntervalSince1970,
                           queryID: String,
                           objectIDs: [String]) {
        do {
            
            let event = try Conversion(name: "",
                                       indexName: indexName,
                                       userToken: effectiveUserToken(withEventUserToken: userToken),
                                       timestamp: timestamp,
                                       queryID: queryID,
                                       objectIDsOrFilters: .objectIDs(objectIDs))
            eventProcessor.process(event)
            
        } catch let error {
            logger.debug(message: error.localizedDescription)
        }
    }
    
    /// Track a conversion
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter queryID: Algolia queryID
    /// - parameter objectID: Index objectID
    
    public func conversion(userToken: String? = .none,
                           indexName: String,
                           timestamp: TimeInterval = Date().timeIntervalSince1970,
                           queryID: String,
                           objectID: String) {
        conversion(userToken: effectiveUserToken(withEventUserToken: userToken),
                   indexName: indexName,
                   queryID: queryID,
                   objectIDs: [objectID])
    }
    
    /// Track a click
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter queryID: Algolia queryID
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    /// - parameter positions: Position of the click in the list of Algolia search results. Positions count must be the same as objectID count.
    
    @objc(clickWithUserToken:indexName:timestamp:queryID:objectIDs:positions:)
    public func z_objc_click(userToken: String,
                             indexName: String,
                             timestamp: TimeInterval,
                             queryID: String,
                             objectIDs: [String],
                             positions: [Int]) {
        guard objectIDs.count == positions.count else {
            let error = EventConstructionError.objectsAndPositionsCountMismatch(objectIDsCount: objectIDs.count, positionsCount: positions.count)
            logger.debug(message: error.localizedDescription)
            return
        }
        
        let objectIDsWithPositions = zip(objectIDs, positions).map { $0 }
        click(userToken: userToken, indexName: indexName, timestamp: timestamp, queryID: queryID, objectIDsWithPositions: objectIDsWithPositions)
    }
        
}

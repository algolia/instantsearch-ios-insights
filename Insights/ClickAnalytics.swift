//
//  ClickAnalytics.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation


/**
Click Analytics helps you answer the following questions: Does a user, after performing a search, click-through to one or more of your products? and does he or she take a particularly significant action, called a “conversion point”?
*/

@objcMembers public class ClickAnalytics: NSObject, AnalyticsUsecase {
    
    var eventProcessor: EventProcessor
    var logger: Logger
    
    init(eventProcessor: EventProcessor, logger: Logger) {
        self.eventProcessor = eventProcessor
        self.logger = logger
    }
    
    // Only for Objective-C
    /// Track a click
    /// - parameter userToken: User identifier
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter queryID: Algolia queryID
    /// - parameter objectIDs: An array of related index objectID. Limited to 20 objects.
    /// - parameter positions: Position of the click in the list of Algolia search results. Positions count must be the same as objectID count.

    @available(swift, obsoleted: 3.1)
    public func click(userToken: String,
                      indexName: String,
                      timestamp: TimeInterval = Date().timeIntervalSince1970,
                      queryID: String,
                      objectIDs: [String],
                      positions: [Int]) {
        
        guard objectIDs.count == positions.count else {
            let error = EventConstructionError.objectsAndPositionsCountMismatch(objectIDsCount: objectIDs.count, positionsCount: positions.count)
            logger.debug(message: error.localizedDescription)
            return
        }
        
        let objectIDsWithPositions = zip(objectIDs, positions).map { $0 }
        
        click(userToken: userToken, indexName: indexName, queryID: queryID, objectIDsWithPositions: objectIDsWithPositions)
    }
    
    ///
    /// Track a click
    /// - parameter userToken: User identifier
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter queryID: Algolia queryID
    /// - parameter objectIDsWithPositions: An array of related index objectID and position of the click in the list of Algolia search results. Limited to 20 objects.
    
    public func click(userToken: String,
                      indexName: String,
                      timestamp: TimeInterval = Date().timeIntervalSince1970,
                      queryID: String,
                      objectIDsWithPositions: [(String, Int)]) {
        do {
            
            let event = try Click(name: "",
                                  indexName: indexName,
                                  userToken: userToken,
                                  timestamp: timestamp,
                                  queryID: queryID,
                                  objectIDsWithPositions: objectIDsWithPositions)
            eventProcessor.process(event)
            
        } catch let error {
            logger.debug(message: error.localizedDescription)
        }

    }
    
    /// Track a conversion
    /// - parameter userToken: User identifier
    /// - parameter indexName: Name of the targeted index
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter queryID: Algolia queryID
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    
    public func conversion(userToken: String,
                           indexName: String,
                           timestamp: TimeInterval = Date().timeIntervalSince1970,
                           queryID: String,
                           objectIDs: [String]) {
        do {
            
            let event = try Conversion(name: "",
                                       indexName: indexName,
                                       userToken: userToken,
                                       timestamp: timestamp,
                                       queryID: queryID,
                                       objectIDsOrFilters: .objectIDs(objectIDs))
            eventProcessor.process(event)
            
        } catch let error {
            logger.debug(message: error.localizedDescription)
        }
    }
    
}

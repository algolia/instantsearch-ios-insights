//
//  ABTesting.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

/**
 A/B Testing allows you to create 2 alternative indices, A and B, each with their own settings,
 and to put them both live, to see which one performs best.
 Capture the same user events for both A and B.
 Measure these captured events against each other, creating scores.
 Use these scores to determine whether A or B is a better user experience.
 Adjust your main index accordingly.
*/

@objcMembers public class ABTesting: NSObject, AnalyticsUsecase {
    
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

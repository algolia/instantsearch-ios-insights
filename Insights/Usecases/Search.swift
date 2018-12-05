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

class Search: NSObject, AnalyticsUsecase, SearchRelatedEventTrackable {
    
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
    
    func click(queryID: String,
               userToken: String? = .none,
               indexName: String,
               timestamp: Int64 = Date().millisecondsSince1970,
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
    
    func click(queryID: String,
               userToken: String? = .none,
               indexName: String,
               timestamp: Int64 = Date().millisecondsSince1970,
               objectIDs: [String],
               positions: [Int]) {
        guard objectIDs.count == positions.count else {
            let error = EventConstructionError.objectsAndPositionsCountMismatch(objectIDsCount: objectIDs.count, positionsCount: positions.count)
            logger.debug(message: error.localizedDescription)
            return
        }
        
        let objectIDsWithPositions = zip(objectIDs, positions).map { $0 }
        click(queryID: queryID,
              userToken: userToken,
              indexName: indexName,
              timestamp: timestamp,
              objectIDsWithPositions: objectIDsWithPositions)
    }
    
    func conversion(queryID: String,
                    userToken: String? = .none,
                    indexName: String,
                    timestamp: Int64 = Date().millisecondsSince1970,
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
    
}

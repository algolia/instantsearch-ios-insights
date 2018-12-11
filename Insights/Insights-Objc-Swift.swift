//
//  Insights-Objc-Swift.swift
//  Insights
//
//  Created by Vladislav Fitc on 10/12/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

/**
 This file contains Objective-C overloads for event tracking methods which cannot be expressed via bridging from Swift.
 Example: tuple as a field type, optional fields
 */

extension Insights {
    
    /// Track a click
    /// - parameter queryID: Algolia queryID
    /// - parameter indexName: Name of the targeted index
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    /// - parameter positions: Position of the click in the list of Algolia search results. Positions count must be the same as objectID count.
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter timestamp: Time of the event expressed in seconds since the unix epoch
    
    @objc(clickAfterSearchWithQueryID:indexName:objectIDs:positions:userToken:timestamp:)
    public func z_objc_clickAfterSearch(withQueryID queryID: String,
                                        indexName: String,
                                        objectIDs: [String],
                                        positions: [Int],
                                        userToken: String?,
                                        timestamp: TimeInterval) {
        
        guard objectIDs.count == positions.count else {
            let error = EventConstructionError.objectsAndPositionsCountMismatch(objectIDsCount: objectIDs.count, positionsCount: positions.count)
            logger.debug(message: error.localizedDescription)
            return
        }
        
        let objectIDsWithPositions = zip(objectIDs, positions).map { $0 }
        
        clickAfterSearch(withQueryID: queryID,
                         indexName: indexName,
                         objectIDsWithPositions: objectIDsWithPositions,
                         userToken: userToken,
                         timestamp: timestamp)
    }
    
    @objc(clickAfterSearchWithQueryID:indexName:objectIDs:positions:userToken:)
    public func z_objc_clickAfterSearch(withQueryID queryID: String,
                                        indexName: String,
                                        objectIDs: [String],
                                        positions: [Int],
                                        userToken: String?) {
        
        z_objc_clickAfterSearch(withQueryID: queryID,
                                indexName: indexName,
                                objectIDs: objectIDs,
                                positions: positions,
                                userToken: userToken,
                                timestamp: Date().timeIntervalSince1970)
    }
    
    @objc(clickAfterSearchWithQueryID:indexName:objectID:position:userToken:)
    public func z_objc_clickAfterSearch(withQueryID queryID: String,
                                        indexName: String,
                                        objectID: String,
                                        position: Int,
                                        userToken: String?) {
        clickAfterSearch(withQueryID: queryID,
                         indexName: indexName,
                         objectID: objectID,
                         position: position,
                         userToken: userToken,
                         timestamp: Date().timeIntervalSince1970)
    }
    
    @objc(conversionAfterSearchWithQueryID:indexName:objectIDs:userToken:)
    public func z_objc_conversionAfterSearch(withQueryID queryID: String,
                                             indexName: String,
                                             objectIDs: [String],
                                             userToken: String?) {
        conversionAfterSearch(withQueryID: queryID,
                              indexName: indexName,
                              objectIDs: objectIDs,
                              userToken: userToken,
                              timestamp: Date().timeIntervalSince1970)
        
    }
    
    @objc(conversionAfterSearchWithQueryID:indexName:objectID:userToken:)
    public func z_objc_conversionAfterSearch(withQueryID queryID: String,
                                             indexName: String,
                                             objectID: String,
                                             userToken: String?) {
        conversionAfterSearch(withQueryID: queryID,
                              indexName: indexName,
                              objectID: objectID,
                              userToken: userToken,
                              timestamp: Date().timeIntervalSince1970)
    }
    
}

extension Insights {
    
    @objc(viewWithEventName:indexName:objectIDs:userToken:)
    public func z_objc_view(eventName: String,
                            indexName: String,
                            objectIDs: [String],
                            userToken: String?) {
        view(eventName: eventName,
             indexName: indexName,
             objectIDs: objectIDs,
             userToken: userToken,
             timestamp: Date().timeIntervalSince1970)
    }
    
    @objc(viewWithEventName:indexName:objectID:userToken:)
    public func z_objc_view(eventName: String,
                            indexName: String,
                            objectID: String,
                            userToken: String?) {
        view(eventName: eventName,
             indexName: indexName,
             objectID: objectID,
             userToken: userToken,
             timestamp: Date().timeIntervalSince1970)
    }
    
    @objc(viewWithEventName:indexName:filters:userToken:)
    public func z_objc_view(eventName: String,
                            indexName: String,
                            filters: [String],
                            userToken: String?) {
        view(eventName: eventName,
             indexName: indexName,
             filters: filters,
             userToken: userToken,
             timestamp: Date().timeIntervalSince1970)
    }
    
    @objc(clickWithEventName:indexName:objectIDs:userToken:)
    public func z_objc_click(eventName: String,
                             indexName: String,
                             objectIDs: [String],
                             userToken: String?) {
        click(eventName: eventName,
              indexName: indexName,
              objectIDs: objectIDs, 
              userToken: userToken,
              timestamp: Date().timeIntervalSince1970)
    }
    
    @objc(clickWithEventName:indexName:objectID:userToken:)
    public func z_objc_click(eventName: String,
                             indexName: String,
                             objectID: String,
                             userToken: String?) {
        click(eventName: eventName,
              indexName: indexName,
              objectID: objectID,
              userToken: userToken,
              timestamp: Date().timeIntervalSince1970)
    }
    
    @objc(clickWithEventName:indexName:filters:userToken:)
    public func z_objc_click(eventName: String,
                             indexName: String,
                             filters: [String],
                             userToken: String?) {
        click(eventName: eventName,
              indexName: indexName,
              filters: filters,
              userToken: userToken,
              timestamp: Date().timeIntervalSince1970)
    }
    
    @objc(conversionWithEventName:indexName:objectIDs:userToken:)
    public func z_objc_conversion(eventName: String,
                                  indexName: String,
                                  objectIDs: [String],
                                  userToken: String?) {
        conversion(eventName: eventName,
                   indexName: indexName,
                   objectIDs: objectIDs,
                   userToken: userToken,
                   timestamp: Date().timeIntervalSince1970)
    }
    
    @objc(conversionWithEventName:indexName:objectID:userToken:)
    public func z_objc_conversion(eventName: String,
                                  indexName: String,
                                  objectID: String,
                                  userToken: String?) {
        conversion(eventName: eventName,
                   indexName: indexName,
                   objectID: objectID,
                   userToken: userToken,
                   timestamp: Date().timeIntervalSince1970)
    }
    
    @objc(conversionWithEventName:indexName:filters:userToken:)
    public func z_objc_conversion(eventName: String,
                                  indexName: String,
                                  filters: [String],
                                  userToken: String?) {
        conversion(eventName: eventName,
                   indexName: indexName,
                   filters: filters,
                   userToken: userToken,
                   timestamp: Date().timeIntervalSince1970)
    }
    
}

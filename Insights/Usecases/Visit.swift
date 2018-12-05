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

class Visit: NSObject, AnalyticsUsecase, CustomEventTrackable {
    
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
    
    func view(eventName: String,
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
    
    func view(eventName: String,
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
    
    func click(eventName: String,
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
    
    func click(eventName: String,
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
    
    func conversion(eventName: String,
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
    
    func conversion(eventName: String,
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

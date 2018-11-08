//
//  View.swift
//  Insights
//
//  Created by Vladislav Fitc on 05/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

public struct View: Event {
    
    internal let coreEvent: CoreEvent
    
    public var type: EventType {
        return coreEvent.type
    }
    
    public var name: String {
        return coreEvent.name
    }
    
    public var indexName: String {
        return coreEvent.indexName
    }
    
    public var userToken: String {
        return coreEvent.userToken
    }
    
    public var timestamp: TimeInterval {
        return coreEvent.timestamp
    }
    
    public var queryID: String? {
        return coreEvent.queryID
    }
    
    public var objectIDsOrFilters: ObjectsIDsOrFilters {
        return coreEvent.objectIDsOrFilters
    }
    
    init(name: String,
         indexName: String,
         userToken: String,
         timestamp: TimeInterval,
         queryID: String?,
         objectIDsOrFilters: ObjectsIDsOrFilters) throws {
        coreEvent = try CoreEvent(type: .view,
                                  name: name,
                                  index: indexName,
                                  userToken: userToken,
                                  timestamp: timestamp,
                                  queryID: queryID,
                                  objectIDsOrFilters: objectIDsOrFilters)
    }
    
}

extension View: Codable {
    
    public init(from decoder: Decoder) throws {
        coreEvent = try CoreEvent(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        try coreEvent.encode(to: encoder)
    }
    
}

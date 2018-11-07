//
//  View.swift
//  Insights
//
//  Created by Vladislav Fitc on 05/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

public struct View: Event {
    
    public var type: EventType {
        return coreEvent.type
    }
    
    public var name: String {
        return coreEvent.name
    }
    
    public var index: String {
        return coreEvent.index
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
    
    internal let coreEvent: CoreEvent
    
    init(name: String,
         index: String,
         userToken: String,
         timestamp: TimeInterval = Date().timeIntervalSince1970,
         queryID: String? = .none,
         objectIDsOrFilters: ObjectsIDsOrFilters) throws {
        coreEvent = try CoreEvent(type: .view,
                                  name: name,
                                  index: index,
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

//
//  Click.swift
//  Insights
//
//  Created by Vladislav Fitc on 05/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

public struct Click: Event {
    
    enum CodingKeys: String, CodingKey {
        case positions
    }
    
    internal let coreEvent: CoreEvent
    public let positions: [Int]?

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
    
    init(name: String,
         index: String,
         userToken: String,
         timestamp: TimeInterval = Date().timeIntervalSince1970,
         queryID: String,
         objectIDsWithPositions: [(String, Int)]) throws {
        
        let objectIDs = objectIDsWithPositions.map { $0.0 }
        coreEvent = try CoreEvent(type: .click,
                                  name: name,
                                  index: index,
                                  userToken: userToken,
                                  timestamp: timestamp,
                                  queryID: queryID,
                                  objectIDsOrFilters: .objectIDs(objectIDs))
        self.positions = objectIDsWithPositions.map { $0.1 }
    }
    
    init(name: String,
         index: String,
         userToken: String,
         timestamp: TimeInterval = Date().timeIntervalSince1970,
         objectIDsOrFilters: ObjectsIDsOrFilters,
         positions: [Int]?) throws {
        coreEvent = try CoreEvent(type: .click,
                                  name: name,
                                  index: index,
                                  userToken: userToken,
                                  timestamp: timestamp,
                                  objectIDsOrFilters: objectIDsOrFilters)
        self.positions = positions
    }
    
}

extension Click: Codable {
    
    public init(from decoder: Decoder) throws {
        coreEvent = try CoreEvent(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        positions = try container.decodeIfPresent([Int].self, forKey: .positions)
    }
    
    public func encode(to encoder: Encoder) throws {
        try coreEvent.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(positions, forKey: .positions)
    }

}

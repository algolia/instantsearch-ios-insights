//
//  CoreEvent.swift
//  Insights
//
//  Created by Vladislav Fitc on 05/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

internal struct CoreEvent: Event, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case type = "eventType"
        case name = "eventName"
        case indexName = "index"
        case userToken
        case timestamp
        case queryID
        case positions
    }
    
    enum Error: Swift.Error {
        case objectIDsCountOverflow
        case filtersCountOverflow
    }
    
    internal static let maxObjectIDsCount = 20
    internal static let maxFiltersCount = 10
    
    let type: EventType
    let name: String
    let indexName: String
    let userToken: String
    let timestamp: TimeInterval
    let queryID: String?
    let objectIDsOrFilters: ObjectsIDsOrFilters
    
    init(type: EventType,
         name: String,
         index: String,
         userToken: String,
         timestamp: TimeInterval,
         queryID: String?,
         objectIDsOrFilters: ObjectsIDsOrFilters) throws {
        
        switch objectIDsOrFilters {
        case .filters(let filters) where filters.count > CoreEvent.maxFiltersCount:
            throw Error.filtersCountOverflow
            
        case .objectIDs(let objectIDs) where objectIDs.count > CoreEvent.maxObjectIDsCount:
            throw Error.objectIDsCountOverflow
            
        default:
            break
        }
        
        self.type = type
        self.name = name
        self.indexName = index
        self.userToken = userToken
        self.timestamp = timestamp
        self.queryID = queryID
        self.objectIDsOrFilters = objectIDsOrFilters
    }
    
    init(event: Event) {
        self.type = event.type
        self.name = event.name
        self.indexName = event.indexName
        self.userToken = event.userToken
        self.timestamp = event.timestamp
        self.queryID = event.queryID
        self.objectIDsOrFilters = event.objectIDsOrFilters
    }
    
}

extension CoreEvent.Error: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .filtersCountOverflow:
            return "Max filters count in event is \(CoreEvent.maxFiltersCount)"
            
        case .objectIDsCountOverflow:
            return "Max objects IDs count in event is \(CoreEvent.maxObjectIDsCount)"
        }
    }
    
}

extension CoreEvent: Codable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(EventType.self, forKey: .type)
        self.name = try container.decode(String.self, forKey: .name)
        self.indexName = try container.decode(String.self, forKey: .indexName)
        self.userToken = try container.decode(String.self, forKey: .userToken)
        self.timestamp = try container.decode(TimeInterval.self, forKey: .timestamp)
        self.queryID = try container.decode(String.self, forKey: .queryID)
        self.objectIDsOrFilters = try ObjectsIDsOrFilters(from: decoder)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(indexName, forKey: .indexName)
        try container.encode(userToken, forKey: .userToken)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(queryID, forKey: .queryID)
        try objectIDsOrFilters.encode(to: encoder)
    }
    
}

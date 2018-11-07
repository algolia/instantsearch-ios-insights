//
//  ObjectIDsOrFilters.swift
//  Insights
//
//  Created by Vladislav Fitc on 05/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

public enum ObjectsIDsOrFilters: Codable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case objectIDs
        case filters
    }
    
    enum Error: Swift.Error {
        
        case decodingFailure
        
        var localizedDescription: String {
            switch self {
            case .decodingFailure:
                return "Neither \(CodingKeys.filters.rawValue), nor \(CodingKeys.objectIDs.rawValue) key found on decoder"
            }
        }
        
    }
    
    case objectIDs([String])
    case filters([Filter])
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let objectIDs = try? container.decode([String].self, forKey: .objectIDs) {
            self = .objectIDs(objectIDs)
        } else if let filters = try? container.decode([Filter].self, forKey: .filters) {
            self = .filters(filters)
        } else {
            throw Error.decodingFailure
        }
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .filters(let filters):
            try container.encode(filters, forKey: .filters)
            
        case .objectIDs(let objectsIDs):
            try container.encode(objectsIDs, forKey: .objectIDs)
        }
        
    }
    
}

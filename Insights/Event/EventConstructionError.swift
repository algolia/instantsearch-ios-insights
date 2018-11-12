//
//  EventConstructionError.swift
//  Insights
//
//  Created by Vladislav Fitc on 12/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

enum EventConstructionError: Error {
    case objectIDsCountOverflow
    case filtersCountOverflow
    case objectsAndPositionsCountMismatch(objectIDsCount: Int, positionsCount: Int)
}

extension EventConstructionError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .filtersCountOverflow:
            return "Max filters count in event is \(CoreEvent.maxFiltersCount)"
            
        case .objectIDsCountOverflow:
            return "Max objects IDs count in event is \(CoreEvent.maxObjectIDsCount)"
            
        case .objectsAndPositionsCountMismatch(objectIDsCount: let objectIDsCount, positionsCount: let positionsCount):
            return "Object IDs count \(objectIDsCount) is not equal to positions count \(positionsCount)"
        }
    }
    
}

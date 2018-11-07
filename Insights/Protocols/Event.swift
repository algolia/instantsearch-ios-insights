//
//  Event.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

public protocol Event {
    
    var type: EventType { get }
    var name: String { get }
    var index: String { get }
    var userToken: String { get }
    var timestamp: TimeInterval { get }
    var queryID: String? { get }
    var objectIDsOrFilters: ObjectsIDsOrFilters { get }
    
}

//
//  Filter.swift
//  Insights
//
//  Created by Vladislav Fitc on 02/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

public struct Filter: RawRepresentable, Codable, Equatable {
    
    public typealias RawValue = String
    
    let name: String
    let value: String
    
    public var rawValue: String {
        return "\(name):\(value)"
    }
    
    public init?(rawValue: String) {
        let components = rawValue.split(separator: ":")
        guard components.count == 2 else { return nil }
        self.name = String(components[0])
        self.value = String(components[1])
    }
    
}

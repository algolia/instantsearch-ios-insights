//
//  Encodable.swift
//  Insights
//
//  Created by Vladislav Fitc on 02/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

extension Encodable {
    
    func jsonObject() throws -> Any {
        let data = try JSONEncoder().encode(self)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }

    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    
    func asArray() throws -> [Any] {
        let data = try JSONEncoder().encode(self)
        guard let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] else {
            throw NSError()
        }
        return array
    }
}

extension Dictionary where Key == String, Value == Any {
    
    init?<T: Encodable>(_ encodable: T) {
        guard let data = try? JSONEncoder().encode(encodable) else { return nil }
        guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any] else {
            return nil
        }
        self = dictionary
    }
    
}

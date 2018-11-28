//
//  EventsPackage.swift
//  Insights
//
//  Created by Vladislav Fitc on 02/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

struct EventsPackage {
    
    static let maxEventCountInPackage = 1000
    static let empty = EventsPackage()
    
    let id: String
    let events: [EventWrapper]
    
    var isFull: Bool {
        return events.count == EventsPackage.maxEventCountInPackage
    }
    
    init(event: EventWrapper) {
        self.id = UUID().uuidString
        self.events = [event]
    }
    
    init() {
        self.id = UUID().uuidString
        self.events = []
    }
    
    init(events: [EventWrapper]) throws {
        guard events.count <= EventsPackage.maxEventCountInPackage else {
            throw Error.packageOverflow
        }
        self.id = UUID().uuidString
        self.events = events
    }
    
    func appending(_ event: EventWrapper) throws -> EventsPackage {
        return try appending([event])
    }
    
    func appending(_ events: [EventWrapper]) throws -> EventsPackage {
        guard events.count + self.events.count <= EventsPackage.maxEventCountInPackage else {
            throw Error.packageOverflow
        }
        return try EventsPackage(events: self.events + events)
    }
    
}

extension EventsPackage: Collection {
    
    typealias Index = Array<EventWrapper>.Index
    typealias Element = Array<EventWrapper>.Element

    var startIndex: Index {
        return events.startIndex
    }
    
    var endIndex: Index {
        return events.endIndex
    }
    
    func index(after i: Index) -> Index {
        return events.index(after: i)
    }
    
    subscript(index: Index) -> Element {
        get { return events[index] }
    }
    
}

extension EventsPackage {
    
    enum Error: Swift.Error {
        case packageOverflow
    }
    
}

extension EventsPackage.Error: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .packageOverflow:
            return "Max events count in package is \(EventsPackage.maxEventCountInPackage)"
        }
    }
    
}

extension EventsPackage: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case events
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.events = try container.decode([EventWrapper].self, forKey: .events)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(events, forKey: .events)
    }
    
}

extension EventsPackage: Hashable {
    
    static func == (lhs: EventsPackage, rhs: EventsPackage) -> Bool {
        return lhs.id == rhs.id
    }
    
    var hashValue: Int {
        return id.hashValue
    }
    
}

extension EventsPackage: Syncable {
    
    @discardableResult func sync() -> Resource<Bool, WebserviceError> {
        
        let errorParse: (Int, Any) -> WebserviceError? = { (code, data) -> WebserviceError? in
            if let data = data as? [String: Any],
                let message = data["message"] as? String {
                let error = WebserviceError(code: code, message: message)
                return error
            }
            return nil
        }
        
        let serializedSelf = Dictionary(self)!

        return Resource<Bool, WebserviceError>(url: API.baseAPIURL,
                                               method: .post([], serializedSelf as AnyObject),
                                               allowEmptyResponse: true,
                                               errorParseJSON: errorParse)
    }
    
}

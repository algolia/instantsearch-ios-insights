import Foundation

public enum ObjectsIDsOrFilters: Equatable {
    case objectIDs([String])
    case filters([String])
}

protocol EventProcessable: class {
    
    var isActive: Bool { get set }
    func process(_ event: Event)
    
}

protocol Event {
    
    var type: EventType { get }
    var name: String { get }
    var indexName: String { get }
    var userToken: String { get }
    var timestamp: Int64 { get }
    var queryID: String? { get }
    var objectIDsOrFilters: ObjectsIDsOrFilters { get }
    
}

enum EventConstructionError: Error {
    case objectIDsCountOverflow
    case filtersCountOverflow
    case objectsAndPositionsCountMismatch(objectIDsCount: Int, positionsCount: Int)
}

struct CoreEvent: Event, Equatable {
    
    internal static let maxObjectIDsCount = 20
    internal static let maxFiltersCount = 10
    
    let type: EventType
    let name: String
    let indexName: String
    let userToken: String
    let timestamp: Int64
    let queryID: String?
    let objectIDsOrFilters: ObjectsIDsOrFilters
    
    init(type: EventType,
         name: String,
         indexName: String,
         userToken: String,
         timestamp: Int64,
         queryID: String?,
         objectIDsOrFilters: ObjectsIDsOrFilters) throws {
        
        switch objectIDsOrFilters {
        case .filters(let filters) where filters.count > CoreEvent.maxFiltersCount:
            throw EventConstructionError.filtersCountOverflow
            
        case .objectIDs(let objectIDs) where objectIDs.count > CoreEvent.maxObjectIDsCount:
            throw EventConstructionError.objectIDsCountOverflow
            
        default:
            break
        }
        
        self.type = type
        self.name = name
        self.indexName = indexName
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

protocol CoreEventContainer: Event {
    var coreEvent: CoreEvent { get }
}

extension CoreEventContainer {
    
    var type: EventType {
        return coreEvent.type
    }
    
    var name: String {
        return coreEvent.name
    }
    
    var indexName: String {
        return coreEvent.indexName
    }
    
    var userToken: String {
        return coreEvent.userToken
    }
    
    var timestamp: Int64 {
        return coreEvent.timestamp
    }
    
    var queryID: String? {
        return coreEvent.queryID
    }
    
    var objectIDsOrFilters: ObjectsIDsOrFilters {
        return coreEvent.objectIDsOrFilters
    }
    
}

enum EventType {
    case click, view, conversion
}

struct Click: CoreEventContainer {
    
    let coreEvent: CoreEvent
    let positions: [Int]?
    
    init(name: String,
         indexName: String,
         userToken: String,
         timestamp: Int64,
         queryID: String,
         objectIDsWithPositions: [(String, Int)]) throws {
        
        let objectIDs = objectIDsWithPositions.map { $0.0 }
        coreEvent = try CoreEvent(type: .click,
                                  name: name,
                                  indexName: indexName,
                                  userToken: userToken,
                                  timestamp: timestamp,
                                  queryID: queryID,
                                  objectIDsOrFilters: .objectIDs(objectIDs))
        self.positions = objectIDsWithPositions.map { $0.1 }
    }
    
    init(name: String,
         indexName: String,
         userToken: String,
         timestamp: Int64,
         objectIDsOrFilters: ObjectsIDsOrFilters,
         positions: [Int]?) throws {
        coreEvent = try CoreEvent(type: .click,
                                  name: name,
                                  indexName: indexName,
                                  userToken: userToken,
                                  timestamp: timestamp,
                                  queryID: .none,
                                  objectIDsOrFilters: objectIDsOrFilters)
        self.positions = positions
    }
    
}

struct View: CoreEventContainer {
    
    let coreEvent: CoreEvent
    
    init(name: String,
         indexName: String,
         userToken: String,
         timestamp: Int64,
         queryID: String?,
         objectIDsOrFilters: ObjectsIDsOrFilters) throws {
        coreEvent = try CoreEvent(type: .view,
                                  name: name,
                                  indexName: indexName,
                                  userToken: userToken,
                                  timestamp: timestamp,
                                  queryID: queryID,
                                  objectIDsOrFilters: objectIDsOrFilters)
    }
    
}

struct Conversion: CoreEventContainer {
    
    let coreEvent: CoreEvent
    
    init(name: String,
         indexName: String,
         userToken: String,
         timestamp: Int64,
         queryID: String?,
         objectIDsOrFilters: ObjectsIDsOrFilters) throws {
        coreEvent = try CoreEvent(type: .conversion,
                                  name: name,
                                  indexName: indexName,
                                  userToken: userToken,
                                  timestamp: timestamp,
                                  queryID: queryID,
                                  objectIDsOrFilters: objectIDsOrFilters)
    }
    
}

public protocol ObjectsPayloadTransferable {
    func with(objectID: String)
    func with(objectIDs: [String])
}

extension ObjectsPayloadTransferable {
    func with(objectID: String) {
        self.with(objectIDs: [objectID])
    }
}

public protocol ObjectsWithPositionPayloadTransferable {
    func with(objectID: String, position: Int)
    func with(objectIDsWithPositions: [(String, Int)])
}

extension ObjectsWithPositionPayloadTransferable {
    func with(objectID: String, position: Int) {
        self.with(objectIDsWithPositions: [(objectID, position)])
    }
}

public protocol FiltersPayloadTransferable {
    func with(filters: [String])
}

public protocol PersoEventGeneratable {
    func event(withName eventName: String) -> (ObjectsPayloadTransferable & FiltersPayloadTransferable)
}

public protocol SearchEventGeneratable {
    func query(withID queryID: String) -> ObjectsPayloadTransferable
}

public protocol SearchEventWithPositionsGeneratable {
    func query(withID queryID: String) -> ObjectsWithPositionPayloadTransferable
}

struct QueryEventGenerator: ObjectsPayloadTransferable {
    
    let queryID: String
    let eventTemplate: EventTemplate
    let eventProcessor: EventProcessable
    
    init(queryID: String,
         eventTemplate: EventTemplate,
         eventProcessor: EventProcessable) {
        self.queryID = queryID
        self.eventTemplate = eventTemplate
        self.eventProcessor = eventProcessor
    }
    
    func with(objectIDs: [String]) {
        event(objectIDsOrFilters: .objectIDs(objectIDs))
    }
    
    private func event(objectIDsOrFilters: ObjectsIDsOrFilters) {
        //do it
    }
    
}

struct QueryWithPositionsEventGenerator: ObjectsWithPositionPayloadTransferable {
    
    let queryID: String
    let eventTemplate: EventTemplate
    let eventProcessor: EventProcessable
    
    init(queryID: String,
         eventTemplate: EventTemplate,
         eventProcessor: EventProcessable) {
        self.queryID = queryID
        self.eventTemplate = eventTemplate
        self.eventProcessor = eventProcessor
    }
    
    func with(objectIDsWithPositions: [(String, Int)]) {
        self.event(objectIDsOrFilters: .objectIDs(objectIDsWithPositions.map { $0.0 }), positions: objectIDsWithPositions.map { $0.1 })
    }
    
    private func event(objectIDsOrFilters: ObjectsIDsOrFilters, positions: [Int]) {
        //do it
    }
    
}

struct PersoEventGenerator: ObjectsPayloadTransferable, FiltersPayloadTransferable {
    
    let eventName: String
    let eventTemplate: EventTemplate
    let eventProcessor: EventProcessable
    
    init(eventName: String,
         eventTemplate: EventTemplate,
         eventProcessor: EventProcessable) {
        self.eventName = eventName
        self.eventTemplate = eventTemplate
        self.eventProcessor = eventProcessor
    }
    
    func with(objectIDs: [String]) {
        event(objectIDsOrFilters: .objectIDs(objectIDs))
    }
    
    func with(filters: [String]) {
        event(objectIDsOrFilters: .filters(filters))
    }
    
    private func event(objectIDsOrFilters: ObjectsIDsOrFilters) {
        
        let event: Event
        
        switch eventTemplate.type {
        case .click:
            event = try! Click(name: eventName,
                               indexName: eventTemplate.indexName,
                               userToken: eventTemplate.userToken,
                               timestamp: eventTemplate.timestamp,
                               objectIDsOrFilters: objectIDsOrFilters,
                               positions: .none)
            
        case .conversion:
            event = try! Conversion(name: eventName,
                                    indexName: eventTemplate.indexName,
                                    userToken: eventTemplate.userToken,
                                    timestamp: eventTemplate.timestamp,
                                    queryID: .none,
                                    objectIDsOrFilters: objectIDsOrFilters)
            
        case .view:
            event = try! View(name: eventName,
                              indexName: eventTemplate.indexName,
                              userToken: eventTemplate.userToken,
                              timestamp: eventTemplate.timestamp,
                              queryID: .none,
                              objectIDsOrFilters: objectIDsOrFilters)
        }
        
        eventProcessor.process(event)
        
    }
    
}


public struct ClickEventGenerator: PersoEventGeneratable, SearchEventWithPositionsGeneratable {
    
    let eventTemplate: EventTemplate
    let eventProcessor: EventProcessable
    
    public func event(withName eventName: String) -> (ObjectsPayloadTransferable & FiltersPayloadTransferable) {
        return PersoEventGenerator(eventName: eventName, eventTemplate: eventTemplate, eventProcessor: eventProcessor)
    }
    
    public func query(withID queryID: String) -> ObjectsWithPositionPayloadTransferable {
        return QueryWithPositionsEventGenerator(queryID: queryID, eventTemplate: eventTemplate, eventProcessor: eventProcessor)
    }
    
}

public struct ViewEventGenerator: PersoEventGeneratable {
    
    let eventTemplate: EventTemplate
    let eventProcessor: EventProcessable
    
    public func event(withName eventName: String) -> (ObjectsPayloadTransferable & FiltersPayloadTransferable) {
        return PersoEventGenerator(eventName: eventName, eventTemplate: eventTemplate, eventProcessor: eventProcessor)
    }
    
}

public struct ConversionEventGenerator: PersoEventGeneratable, SearchEventGeneratable {
    
    let eventTemplate: EventTemplate
    let eventProcessor: EventProcessable

    public func event(withName eventName: String) -> (ObjectsPayloadTransferable & FiltersPayloadTransferable) {
        return PersoEventGenerator(eventName: eventName, eventTemplate: eventTemplate, eventProcessor: eventProcessor)
    }
    
    public func query(withID queryID: String) -> ObjectsPayloadTransferable {
        return QueryEventGenerator(queryID: queryID, eventTemplate: eventTemplate, eventProcessor: eventProcessor)
    }
    
}

struct EventTemplate {
    
    let type: EventType
    let indexName: String
    let userToken: String
    let timestamp: Int64
    
    init(type: EventType, indexName: String, userToken: String? = .none, timestamp: Int64?) {
        self.type = type
        self.indexName = indexName
        self.userToken = userToken ?? "Global token"
        self.timestamp = timestamp ?? Int64(Date().timeIntervalSince1970)
    }
    
}


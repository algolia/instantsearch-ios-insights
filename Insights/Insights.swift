//
//  Insights.swift
//  Insights
//
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

/// Main class used for interacting with the InstantSearch Insights library.
///
/// Use:
/// In order to send insights, you first need to register an APP ID and API key
///
/// Once registered, you can simply call `Insights.shared` to send your events
///
/// Example:
/// ````
/// Insights.shared?.search.click(userToken: "user101",
///                               indexName: "myAwesomeIndex",
///                               queryID: "6de2f7eaa537fa93d8f8f05b927953b1",
///                               objectID: "54675051",
///                               position: 1)
/// ````

@objcMembers public class Insights: NSObject {
    
    private static var insightsMap: [String: Insights] = [:]
    
    /// Specify the desired API endpoint region
    /// By default API endpoint is routed automatically

    public static var region: Region?
    private static var logger = Logger("Main")
    
    /// Global application user token
    /// Generated while the first app launch and than stored persistently
    /// Used as a default user token if no user token provided for event or application
    
    public static var userToken: String {
        
        let key = "com.algolia.InstantSearch.Insights.UserToken"
        
        if let existingToken = UserDefaults.standard.string(forKey: key) {
            return existingToken
        } else {
            let generatedToken = UUID().uuidString
            UserDefaults.standard.set(generatedToken, forKey: key)
            return generatedToken
        }
        
    }
    
    /// Defines if event tracking is active. Default value is `true`.
    /// In case of set to false, all the events for current application will be ignored.
    
    public var isActive: Bool {
        
        get {
            return eventsProcessor.isActive
        }
        
        set {
            eventsProcessor.isActive = newValue
        }
        
    }
        
    /// Register your index with a given appId and apiKey
    ///
    /// - parameter  appId: The given app id for which you want to track the events
    /// - parameter  apiKey: The API Key for your `appId`
    /// - parameter  userToken: User token used by default for all the application events, if custom user token is not provided while calling event capturing function

    @discardableResult public static func register(appId: String,
                                                   apiKey: String,
                                                   userToken: String? = .none) -> Insights {
        let credentials = Credentials(appId: appId, apiKey: apiKey)
        let logger = Logger(appId) { debugMessage in
            DispatchQueue.main.async { print(debugMessage) }
        }
        let sessionConfig = Algolia.SessionConfig.default(appId: appId, apiKey: apiKey)
        let webservice = WebService(sessionConfig: sessionConfig,
                                    logger: logger)
        let insights = Insights(credentials: credentials,
                                webService: webservice,
                                flushDelay: Algolia.Insights.flushDelay,
                                logger: logger)
        Insights.insightsMap[appId] = insights
        return insights
    }
    
    /// Access an already registered `Insights` without having to pass the `apiKey` and `appId`.
    /// If none or more than one application has been registered, the nil value will be returned.

    public static var shared: Insights? {
        
        switch insightsMap.count {
        case 0:
            logger.debug(message: "None registered application found. Please use `register(appId: String, apiKey: String)` method to register your application.")
        
        case 1:
            break
            
        default:
            logger.debug(message: "Multiple applications registered. Please use `shared(appId: String)` function to specify the applicaton.")
            return nil
        }
        
        insightsMap.first?.value.clickAfterSearch(withQueryID: "6de2f7eaa537fa93d8f8f05b927953b1",
                                                  indexName: "myAwesomeIndex",
                                                  userToken: "user101",
                                                  objectID: "54675051",
                                                  position: 1)
        
        return insightsMap.first?.value
    }
    
    /// Access an already registered `Insights` via its `appId`.
    /// If the application was not registered before, the nil value will be returned.
    /// - parameter  appId: The appId of application that is being tracked

    public static func shared(appId: String) -> Insights? {
        logger.debug(message: "Application for this app ID (\(appId)) is not registered. Please use `register(appId: String, apiKey: String)` method to register your application.")
        return insightsMap[appId]
    }
    
    /// Defines if console debug logging enabled. Default value is `false`.

    public var loggingEnabled: Bool = false {
        didSet {
            logger.enabled = loggingEnabled
        }
    }
    
    let eventsProcessor: EventProcessable
    let logger: Logger
    
    /// Access point for capturing of search-related events

    let searchEventTracker: SearchEventTrackable
    
    /// Access point for capturing of personalisation events

    let customEventTracker: CustomEventTrackable
    
    init(eventsProcessor: EventProcessable,
         searchEventTracker: SearchEventTrackable,
         customEventTracker: CustomEventTrackable,
         logger: Logger) {
        self.eventsProcessor = eventsProcessor
        self.searchEventTracker = searchEventTracker
        self.customEventTracker = customEventTracker
        self.logger = logger
    }
    
    convenience init(eventsProcessor: EventProcessable,
                     userToken: String? = .none,
                     logger: Logger) {
        let search = Search(eventProcessor: eventsProcessor,
                                    logger: logger,
                                 userToken: userToken)
        let visit = Visit(eventProcessor: eventsProcessor,
                                  logger: logger,
                               userToken: userToken)
        self.init(eventsProcessor: eventsProcessor,
                  searchEventTracker: search,
                  customEventTracker: visit,
                  logger: logger)
    }
    
    convenience init(credentials: Credentials,
                     webService: WebService,
                     flushDelay: TimeInterval,
                     region: Region? = .none,
                     userToken: String? = .none,
                     logger: Logger) {
        let eventsProcessor = EventsProcessor(
            credentials: credentials,
            webService: webService,
            region: region,
            flushDelay: flushDelay,
            logger: logger)
        self.init(eventsProcessor: eventsProcessor,
                  userToken: userToken,
                  logger: logger)
    }
    
}

// MARK: - Tracking events tighten to search

extension Insights {
    
    /// Track a click
    /// - parameter queryID: Algolia queryID
    /// - parameter indexName: Name of the targeted index
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectIDsWithPositions: An array of related index objectID and position of the click in the list of Algolia search results. - Warning: Limited to 20 objects.
    
    public func clickAfterSearch(withQueryID queryID: String,
                                 indexName: String,
                                 userToken: String? = .none,
                                 timestamp: TimeInterval = Date().timeIntervalSince1970,
                                 objectIDsWithPositions: [(String, Int)]) {
        searchEventTracker.click(queryID: queryID,
                                        indexName: indexName,
                                        userToken: userToken,
                                        timestamp: timestamp.milliseconds,
                                        objectIDsWithPositions: objectIDsWithPositions)
    }
    
    /// Track a click
    /// - parameter queryID: Algolia queryID
    /// - parameter indexName: Name of the targeted index
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectID: Index objectID
    /// - parameter position: Position of the click in the list of Algolia search results
    
    public func clickAfterSearch(withQueryID queryID: String,
                                 indexName: String,
                                 userToken: String? = .none,
                                 timestamp: TimeInterval = Date().timeIntervalSince1970,
                                 objectID: String,
                                 position: Int) {
        searchEventTracker.click(queryID: queryID,
                                        indexName: indexName,
                                        userToken: userToken,
                                        timestamp: timestamp.milliseconds,
                                        objectIDsWithPositions: [(objectID, position)])
    }
    
    /// Track a conversion
    /// - parameter queryID: Algolia queryID
    /// - parameter indexName: Name of the targeted index
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    
    public func conversionAfterSearch(withQueryID queryID: String,
                                      indexName: String,
                                      userToken: String? = .none,
                                      timestamp: TimeInterval = Date().timeIntervalSince1970,
                                      objectIDs: [String]) {
        searchEventTracker.conversion(queryID: queryID,
                                             indexName: indexName,
                                             userToken: userToken,
                                             timestamp: timestamp.milliseconds,
                                             objectIDs: objectIDs)
    }
    
    /// Track a conversion
    /// - parameter queryID: Algolia queryID
    /// - parameter indexName: Name of the targeted index
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectID: Index objectID
    
    public func conversionAfterSearch(withQueryID queryID: String,
                                      indexName: String,
                                      userToken: String? = .none,
                                      timestamp: TimeInterval = Date().timeIntervalSince1970,
                                      objectID: String) {
        searchEventTracker.conversion(queryID: queryID,
                                             indexName: indexName,
                                             userToken: userToken,
                                             timestamp: timestamp.milliseconds,
                                             objectIDs: [objectID])
    }
    
    /// Track a click
    /// - parameter queryID: Algolia queryID
    /// - parameter indexName: Name of the targeted index
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    /// - parameter positions: Position of the click in the list of Algolia search results. Positions count must be the same as objectID count.
    
    @objc(clickAfterSearchWithQueryID:indexName:userToken:timestamp:objectIDs:positions:)
    public func z_objc_click(queryID: String,
                             indexName: String,
                             userToken: String,
                             timestamp: TimeInterval,
                             objectIDs: [String],
                             positions: [Int]) {
        searchEventTracker.click(queryID: queryID,
                                 indexName: indexName,
                                 userToken: userToken,
                                 timestamp: timestamp.milliseconds,
                                 objectIDs: objectIDs,
                                 positions: positions)
    }
    
}

// MARK: - Tracking events non-tighten to search

extension Insights {
    
    /// Track a view
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    
    public func view(eventName: String,
                     indexName: String,
                     userToken: String? = .none,
                     timestamp: TimeInterval = Date().timeIntervalSince1970,
                     objectIDs: [String]) {
        customEventTracker.view(eventName: eventName,
                   indexName: indexName,
                   userToken: userToken,
                   timestamp: timestamp.milliseconds,
                   objectIDs: objectIDs)
    }
    
    /// Track a view
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectID: Index objectID.
    
    public func view(eventName: String,
                     indexName: String,
                     userToken: String? = .none,
                     timestamp: TimeInterval = Date().timeIntervalSince1970,
                     objectID: String) {
        customEventTracker.view(eventName: eventName,
                   indexName: indexName,
                   userToken: userToken,
                   timestamp: timestamp.milliseconds,
                   objectIDs: [objectID])
    }
    
    /// Track a view
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter filters: An array of filters. Limited to 10 filters.
    
    public func view(eventName: String,
                     indexName: String,
                     userToken: String? = .none,
                     timestamp: TimeInterval = Date().timeIntervalSince1970,
                     filters: [String]) {
        customEventTracker.view(eventName: eventName,
                   indexName: indexName,
                   userToken: userToken,
                   timestamp: timestamp.milliseconds,
                   filters: filters)
    }
    
    /// Track a click
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    
    public func click(eventName: String,
                      indexName: String,
                      userToken: String? = .none,
                      timestamp: TimeInterval = Date().timeIntervalSince1970,
                      objectIDs: [String]) {
        customEventTracker.click(eventName: eventName,
                    indexName: indexName,
                    userToken: userToken,
                    timestamp: timestamp.milliseconds,
                    objectIDs: objectIDs)
    }
    
    /// Track a click
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectID: Index objectID.
    
    public func click(eventName: String,
                      indexName: String,
                      userToken: String? = .none,
                      timestamp: TimeInterval = Date().timeIntervalSince1970,
                      objectID: String) {
        customEventTracker.click(eventName: eventName,
                    indexName: indexName,
                    userToken: userToken,
                    timestamp: timestamp.milliseconds,
                    objectIDs: [objectID])
    }
    
    /// Track a click
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter filters: An array of filters. Limited to 10 filters.
    
    public func click(eventName: String,
                      indexName: String,
                      userToken: String? = .none,
                      timestamp: TimeInterval = Date().timeIntervalSince1970,
                      filters: [String]) {
        customEventTracker.click(eventName: eventName,
                    indexName: indexName,
                    userToken: userToken,
                    timestamp: timestamp.milliseconds,
                    filters: filters)
    }
    
    /// Track a conversion
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectIDs: An array of index objectID. Limited to 20 objects.
    
    public func conversion(eventName: String,
                           indexName: String,
                           userToken: String? = .none,
                           timestamp: TimeInterval = Date().timeIntervalSince1970,
                           objectIDs: [String]) {
        customEventTracker.conversion(eventName: eventName,
                         indexName: indexName,
                         userToken: userToken,
                         timestamp: timestamp.milliseconds,
                         objectIDs: objectIDs)
    }
    
    /// Track a conversion
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter objectID: Index objectID.
    
    public func conversion(eventName: String,
                           indexName: String,
                           userToken: String? = .none,
                           timestamp: TimeInterval = Date().timeIntervalSince1970,
                           objectID: String) {
        customEventTracker.conversion(eventName: eventName,
                         indexName: indexName,
                         userToken: userToken,
                         timestamp: timestamp.milliseconds,
                         objectIDs: [objectID])
    }
    
    /// Track a conversion
    /// - parameter eventName: A user-defined string used to categorize events
    /// - parameter indexName: Name of the targeted index
    /// - parameter userToken: User identifier. Overrides application's user token if specified. Default value is nil.
    /// - parameter timestamp: Time of the event expressed in ms since the unix epoch
    /// - parameter filters: An array of filters. Limited to 10 filters.
    
    public func conversion(eventName: String,
                           indexName: String,
                           userToken: String? = .none,
                           timestamp: TimeInterval = Date().timeIntervalSince1970,
                           filters: [String]) {
        customEventTracker.conversion(eventName: eventName,
                         indexName: indexName,
                         userToken: userToken,
                         timestamp: timestamp.milliseconds,
                         filters: filters)
    }
    
}

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
    
    /// Register your index with a given appId and apiKey
    ///
    /// - parameter  appId: The given app id for which you want to track the events
    /// - parameter  apiKey: The API Key for your `appId`

    @discardableResult public static func register(appId: String, apiKey: String) -> Insights {
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
        
        insightsMap.first?.value.search.click(userToken: "user101",
                                              indexName: "myAwesomeIndex",
                                              queryID: "6de2f7eaa537fa93d8f8f05b927953b1",
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
    
    public var loggingEnabled: Bool = false {
        didSet {
            logger.enabled = loggingEnabled
        }
    }
    
    private let eventsProcessor: EventProcessable
    private let logger: Logger
    
    /// Access point for capturing of search-related events

    public let search: Search
    
    /// Access point for capturing of personalisation events

    public let visit: Visit
    
    internal init(credentials: Credentials,
                  webService: WebService,
                  flushDelay: TimeInterval,
                  logger: Logger) {
        let eventsProcessor = EventsProcessor(
            credentials: credentials,
            webService: webService,
            flushDelay: flushDelay,
            logger: logger)
        self.eventsProcessor = eventsProcessor
        self.search = Search(eventProcessor: eventsProcessor, logger: logger)
        self.visit = Visit(eventProcessor: eventsProcessor, logger: logger)
        self.logger = logger
        super.init()
    }
    
}

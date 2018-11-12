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
/// Once registered, you can simply call `Insights.shared(appID: String)` to send your events
///
/// Example:
/// ````
/// try? Insights.shared(appId: "APPID")?.clickAnalytics.click(userToken: "user101",
///                                                            indexName: "myAwesomeIndex",
///                                                            queryID: "6de2f7eaa537fa93d8f8f05b927953b1",
///                                                            objectIDsWithPositions: [("54675051", 1)])
/// ````
///

@objcMembers public class Insights: NSObject {
    
    private static var insightsMap: [String: Insights] = [:]
    
    /// Register your index with a given appId and apiKey
    ///
    /// - parameter  appId: The given app id for which you want to track the events
    /// - parameter  apiKey: The API Key for your `appId`
    ///
    @discardableResult public static func register(appId: String, apiKey: String) -> Insights {
        let credentials = Credentials(appId: appId, apiKey: apiKey)
        let logger = Logger(appId)
        let sessionConfig =  Algolia.SessionConfig.default(appId: appId, apiKey: apiKey)
        let webservice = WebService(sessionConfig: sessionConfig,
                                    logger: logger)
        let insights = Insights(credentials: credentials,
                                webService: webservice,
                                flushDelay: Algolia.Insights.flushDelay,
                                logger: logger)
        Insights.insightsMap[appId] = insights
        return insights
    }
    
    /// Access an already registered `Insights` without having to pass the `apiKey` and `appId`. If the application was not register before, it will return a nil value.
    /// If more than one application has been registered, an undetermined instance of `Insights` will be returned.
    ///
    
    public static var shared: Insights? {
        return insightsMap.first?.value
    }
    
    /// Access an already registered `Insights` via its `appId`. If the application was not register before, it will return a nil value.
    /// - parameter  appId: The appId of application that is being tracked
    ///
    public static func shared(appId: String) -> Insights? {
        return insightsMap[appId]
    }
    
    public var loggingEnabled: Bool = false {
        didSet {
            eventSynchornizer.logger.enabled = loggingEnabled
        }
    }
    
    private let eventSynchornizer: EventsSynchronizer
    public let personalization: Personalization
    public let abTesting: ABTesting
    public let clickAnalytics: ClickAnalytics
    
    internal init(credentials: Credentials,
                  webService: WebService,
                  flushDelay: TimeInterval,
                  logger: Logger) {
        let eventSynchornizer = EventsSynchronizer(
            credentials: credentials,
            webService: webService,
            flushDelay: flushDelay,
            logger: logger)
        self.eventSynchornizer = eventSynchornizer
        self.personalization = Personalization(eventProcessor: eventSynchornizer)
        self.abTesting = ABTesting(eventProcessor: eventSynchornizer)
        self.clickAnalytics = ClickAnalytics(eventProcessor: eventSynchornizer)
        super.init()
    }
    
}

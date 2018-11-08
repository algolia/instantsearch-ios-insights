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
/// In order to send insights, you first need to register an APP ID and API key for a given Index
///
/// Once registered, you can simply call `Insights.shared(index: String)` to send your events
///
/// Example:
///
///     let indexName = "myAwesomeIndex"
///     Insights.register(appId: "APPID", apiKey: "APIKEY", indexName: indexName)
///
///     let clickData: [String : Any] = [
///       "eventName": "My super event",
///       "queryID": "6de2f7eaa537fa93d8f8f05b927953b1",
///       "position": 1,
///       "objectID": "54675051",
///       "indexName": indexName,
///       "timestamp": Date.timeIntervalBetween1970AndReferenceDate
///      ]
///
///     Insights.shared(index: indexName).click(params: data)
@objcMembers public class Insights: NSObject {
    
    private static var insightsMap: [String: Insights] = [:]
    
    /// Register your index with a given appId and apiKey
    ///
    /// - parameter  appId:   The given app id for which you want to track the events
    /// - parameter  apiKey: The API Key for your `appId`
    /// - parameter  indexName: The index that is being tracked
    ///
    @discardableResult public static func register(appId: String, apiKey: String, indexName: String) -> Insights {
        let credentials = Credentials(appId: appId, apiKey: apiKey)
        let logger = Logger(indexName)
        let webservice = WebService(sessionConfig: Algolia.SessionConfig.default(appId: appId, apiKey: apiKey),
                                    logger: logger)
        let insights = Insights(credentials: credentials,
                                webService: webservice,
                                flushDelay: Algolia.Insights.flushDelay,
                                logger: logger)
        Insights.insightsMap[indexName] = insights
        return insights
    }
    
    /// Access an already registered `Insights` without having to pass the `apiKey` and `appId`. If the index was not register before, it will return a nil value
    /// - parameter  index: The index that is being tracked
    ///
    public static func shared(index: String) -> Insights? {
        return insightsMap[index]
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
    
    internal init(credentials: Credentials, webService: WebService, flushDelay: TimeInterval, logger: Logger) {
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

public enum InsightsException: Error {
    case credentialsNotFound(String)
}

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
        let credentials = Credentials(appId: appId, apiKey: apiKey, indexName: indexName)
        let logger = Logger(credentials.indexName)
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
            logger.enabled = loggingEnabled
        }
    }
    
    public lazy var personalization: Personalization = {
        return Personalization(eventProcessor: self)
    }()
    
    public lazy var abTesting: ABTesting = {
       return ABTesting(eventProcessor: self)
    }()
    
    public lazy var clickAnalytics: ClickAnalytics = {
        return ClickAnalytics(eventProcessor: self)
    }()
    
    private let credentials: Credentials
    private var eventsPackages: [EventsPackage] = []
    private let webservice: WebService
    private let logger: Logger
    private var flushTimer: Timer!
    
    internal init(credentials: Credentials, webService: WebService, flushDelay: TimeInterval, logger: Logger) {
        self.credentials = credentials
        self.logger = logger
        self.webservice = webService
        super.init()
        deserialize()
        self.flushTimer = Timer.scheduledTimer(timeInterval: flushDelay, target: self, selector: #selector(flushEvents), userInfo: nil, repeats: true)
    }
    
    private func process(event: EventWrapper) {
        
        let eventsPackage: EventsPackage
        
        if let lastEventsPackage = eventsPackages.last, !lastEventsPackage.isFull {
            // We are sure that try! will not crash, as where is "not full" check
            eventsPackage = try! eventsPackages.removeLast().appending(event)
        } else {
            eventsPackage = EventsPackage(event: event)
        }
        
        eventsPackages.append(eventsPackage)
        
        sync(eventsPackage: eventsPackage)
        
        serialize()
        
    }
    
    @objc func flushEvents() {
        flush(eventsPackages)
    }
    
    private func flush(_ eventsPackages: [EventsPackage]) {
        logger.debug(message: "Flushing remaining events")
        eventsPackages.forEach(sync)
    }
    
    private func sync(eventsPackage: EventsPackage) {
        logger.debug(message: "Syncing \(eventsPackage)")
        webservice.sync(event: eventsPackage) {[weak self] err in
            
            // If there is no error or the error is from the Analytics we should remove it. In case of a WebserviceError the event was wronlgy constructed
            if err == nil || err is WebserviceError {
                self?.remove(eventsPackage: eventsPackage)
            }
        }
    }
    
    private func remove(eventsPackage: EventsPackage) {
        eventsPackages.removeAll(where: { $0.id == eventsPackage.id })
        serialize()
    }
    
    private func serialize() {
        if let file = LocalStorage<[EventsPackage]>.filePath(for: credentials.indexName) {
            LocalStorage<[EventsPackage]>.serialize(eventsPackages, file: file)
        } else {
            logger.debug(message: "Error creating a file for \(credentials.indexName)")
        }
    }
    
    private func deserialize() {
        guard let filePath = LocalStorage<[EventsPackage]>.filePath(for: credentials.indexName) else {
            logger.debug(message: "Error reading a file for \(credentials.indexName)")
            return
        }
        self.eventsPackages = LocalStorage<[EventsPackage]>.deserialize(filePath) ?? []
    }
    
    deinit {
        flushTimer.invalidate()
    }
    
}

extension Insights: EventProcessor {
    
    func process(_ event: Event) {
        let eventWrapper = EventWrapper(event)
        process(event: eventWrapper)
    }
    
}

@objcMembers public class Credentials: NSObject {
    
    let appId: String
    let apiKey: String
    let indexName: String
    
    init(appId: String, apiKey: String, indexName: String) {
        self.appId = appId
        self.apiKey = apiKey
        self.indexName = indexName
        super.init()
    }
}

public enum InsightsException: Error {
    case credentialsNotFound(String)
}

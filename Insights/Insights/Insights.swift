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
  
  /// Access an already registered `Insights` without having to pass the `apiKey` and `appId`
  /// - parameter  index: The index that is being tracked
  ///
  public static func shared(index: String) throws -> Insights {
    if let insights = insightsMap[index] {
      return insights
    }
    
    throw InsightsException.credentialsNotFound("Credentials not found for index \(index)")
  }
  
  public var loggingEnabled: Bool = false {
    didSet {
      logger.enabled = loggingEnabled
    }
  }
  
  
  private let credentials: Credentials
  private var events: [Event] = []
  private let webservice: WebService
  private let logger: Logger
  private var flushTimer: Timer!
  
  internal init(credentials: Credentials, webService: WebService, flushDelay: TimeInterval, logger: Logger) {
    self.credentials = credentials
    self.logger = logger
    self.webservice = webService
    super.init()
    self.flushTimer = Timer.scheduledTimer(withTimeInterval: flushDelay,
                                           repeats: true,
                                           block: {[weak self] _ in
                                            self?.flush()
    })
    deserialize()
  }
  
  /// Track a click
  ///
  /// For a complete list of mandatory fields, check: https://www.algolia.com/doc/rest-api/analytics/#post-click-event
  /// - parameter params: a list of data points that you want to track
  ///
  public func click(params: [String: Any]) {
    process(event: Event(params: params, event: API.Event.click))
  }
  
  
  /// Track a conversion
  ///
  /// For a complete list of mandatory fields, check: https://www.algolia.com/doc/rest-api/analytics/#post-conversion-event
  /// - parameter params: a list of data points that you want to track
  ///
  public func conversion(params: [String: Any]) {
    process(event: Event(params: params, event: API.Event.conversion))
  }
  
  
  /// Track a view
  ///
  /// For a complete list of mandatory fields, check: https://www.algolia.com/doc/rest-api/analytics/#post-view-event
  /// - parameter params: a list of data points that you want to track
  ///
  public func view(params: [String: Any]) {
    process(event: Event(params: params, event: API.Event.view))
  }
  
  private func process(event: Event) {
    events.append(event)
    sync(event)
    serialize()
  }
  
  private func flush() {
    logger.debug(message: "Flushing remaing events")
    events.forEach(sync)
  }

  private func sync(_ event: Event) {
    logger.debug(message: "Syncing \(event)")
    webservice.sync(event: event) {[weak self] success in
      if success {
        self?.remove(event: event)
      }
    }
  }

  private func remove(event: Event) {
    events = events.filter { $0 != event }
    serialize()
  }

  func serialize() {
    if let file = LocalStorage<[Event]>.filePath(for: credentials.indexName) {
      LocalStorage<[Event]>.serialize(events, file: file)
    } else {
      logger.debug(message: "Error creating a file for \(credentials.indexName)")
    }
  }

  private func deserialize() {
    guard let filePath = LocalStorage<[Event]>.filePath(for: credentials.indexName) else {
      logger.debug(message: "Error reading a file for \(credentials.indexName)")
      return
    }
    self.events = LocalStorage<[Event]>.deserialize(filePath) ?? []
  }

  deinit {
    flushTimer.invalidate()
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

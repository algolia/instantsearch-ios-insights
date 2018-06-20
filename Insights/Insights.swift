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
    deserialize()
    self.flushTimer =  Timer.scheduledTimer(timeInterval: flushDelay, target: self, selector: #selector(flushEvents), userInfo: nil, repeats: true)
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
  /// TODO: For this version, the view event is not supported
  private func view(params: [String: Any]) {
    process(event: Event(params: params, event: API.Event.view))
  }
  
  private func process(event: Event) {
    events.append(event)
    sync(event: event)
    serialize()
  }
  
  @objc func flushEvents() {
      flush(self.events)
  }
  
  private func flush(_ events: [Event]) {
    logger.debug(message: "Flushing remaining events")
    events.forEach(sync)
  }

  private func sync(event: Event) {
    logger.debug(message: "Syncing \(event)")
    webservice.sync(event: event) {[weak self] err in

      // If there is no error or the error is from the Analytics we should remove it. In case of a WebserviceError the event was wronlgy constructed
      let webServiceError = err as? WebserviceError
      if err == nil || webServiceError != nil {
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

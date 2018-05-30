//
//  Insights.swift
//  Insights
//
//  Copyright © 2018 Algolia. All rights reserved.
//

import UIKit


/// Main class used for interacting with the InstantSearch Insights library.
/// TODO: Add explination on how to register credentials
@objcMembers public class Insights: NSObject {
  
  private static var insightsMapping: [String: Insights] = [:]
  
  /// The singleton reference of Insights.
  /// Use this only after you registered your credentials for the index
  public static func shared(index: String) throws -> Insights {
    if let insights = insightsMapping[index] {
      return insights
    }
    
    throw InsightsException.CredentialsNotFound("Credentials not found for index \(index)")
  }
  
  // This should be done once to register the api key for the index
  @discardableResult public static func register(appId: String, apiKey: String, indexName: String) -> Insights {
    let credentials = Credentials(appId: appId, apiKey: apiKey, indexName: indexName)
    let insights = Insights(credentials: credentials)
    Insights.insightsMapping[indexName] = insights
    return insights
  }
  
  
  private let credentials: Credentials
  var events: [Event] = []
  let eventsSync: EventsSync
  
  private init(credentials: Credentials) {
    self.credentials = credentials
    self.eventsSync = EventsSync(webservice: WebService(credentials: credentials))
    super.init()
  }
  
  public func click(queryId: String, objectId: String, position: UInt) {
    let event = ClickEvent(name: "t", timestamp: Date.timeIntervalBetween1970AndReferenceDate, userID: "s", queryID: queryId)
    process(event: event)
  }
  
  public func conversion(queryId: String, objectId: String) {
    
  }
  
  public func view(eventName: String, timestamp: TimeInterval, userId: String?, objectIds: [String]) {
    let event = ViewEvent(name: eventName, timestamp: timestamp, userID: userId, objIdsOrFilter: Either<[String], String>.left(objectIds))
    process(event: event)
  }
  
  public func view(eventName: String, timestamp: TimeInterval, userId: String?, filterValue: String) {
    let event = ViewEvent(name: eventName, timestamp: timestamp, userID: userId, objIdsOrFilter: Either<[String], String>.right(filterValue))
    process(event: event)
  }
  
  
  /// helper method, we try to link the objectId to the queryId
  private func conversion(objectId: String) {}
  
  
  private func process(event: Event) {
    events.append(event)
    eventsSync.syncEvent(event: event)
    serialize()
  }
  
  private func serialize() {
    
  }
  
  private func deserialize() {
    
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
  case CredentialsNotFound(String)
}

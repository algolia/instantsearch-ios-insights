//
//  Insights.swift
//  Insights
//
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation


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
  
  public func click(params: [String: Any]) {
    process(event: Event(params: params, event: API.Event.click))
  }
  
  public func conversion(params: [String: Any]) {
    process(event: Event(params: params, event: API.Event.conversion))
  }
  
  public func view(params: [String: Any]) {
    process(event: Event(params: params, event: API.Event.view))
  }
  
  private func process(event: Event) {
    events.append(event)
    eventsSync.syncEvent(event: event) { success in
      print(success)
    }
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

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
  
  private static var insightsMap: [String: Insights] = [:]
  
  /// The singleton reference of Insights.
  /// Use this only after you registered your credentials for the index
  public static func shared(index: String) throws -> Insights {
    if let insights = insightsMap[index] {
      return insights
    }
    
    throw InsightsException.CredentialsNotFound("Credentials not found for index \(index)")
  }
  
  // This should be done once to register the api key for the index
  @discardableResult public static func register(appId: String, apiKey: String, indexName: String) -> Insights {
    let credentials = Credentials(appId: appId, apiKey: apiKey, indexName: indexName)
    let insights = Insights(credentials: credentials)
    Insights.insightsMap[indexName] = insights
    return insights
  }
  
  
  private let credentials: Credentials
  private var events: [Event] = []
  private let webservice: WebService
  
  private init(credentials: Credentials) {
    self.credentials = credentials
    self.webservice = WebService(credentials: credentials)
    super.init()
    deserialize()
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
    webservice.sync(event: event) {[weak self] success in
      if success {
        self?.remove(event: event)
      }
    }
    serialize()
  }
  
  private func remove(event: Event) {
    events = events.filter{ $0 != event }
    serialize()
  }
  
  func serialize() {
    if let file = LocalStorage<[Event]>.filePath(for: credentials.indexName) {
      LocalStorage<[Event]>.serialize(events, file: file)
    } else {
      //TODO: Log an error or something
    }
  }
  
  private func deserialize() {
    guard let filePath = LocalStorage<[Event]>.filePath(for: credentials.indexName) else {
      // TODO: Log the error
      return
    }
    self.events = LocalStorage<[Event]>.deserialize(filePath) ?? []
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

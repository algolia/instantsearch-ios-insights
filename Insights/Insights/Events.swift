//
//  Events.swift
//  Insights
//

//  Copyright © 2018 Algolia. All rights reserved.
//

import UIKit


protocol EventSync {
  func sync() -> Resource<Void, String>
}

protocol Event: EventSync {
  var eventType: String { get }
  var eventName: String { get }
  var timestamp: TimeInterval { get }
  var userID: String? { get }
}

struct ViewEvent: Event, EventSync {
  var eventType: String
  var eventName: String
  var timestamp: TimeInterval
  var userID: String?
  
  static let EVENT_NAME = "View"
  
  let objIdsOrFilter: Either<[String], String>
  
  public init(name: String, timestamp: TimeInterval, userID: String?, objIdsOrFilter: Either<[String], String>) {

    self.eventType = ViewEvent.EVENT_NAME
    self.eventName = name
    self.timestamp = timestamp
    self.userID = userID
    self.objIdsOrFilter = objIdsOrFilter
  }
  
  func sync() -> Resource<Void, String> {
    let params = ["a": "a"]
    return Resource<Void, String>(url: API.url(route: API.Endpoint.view),
                                  method: .post([], params as AnyObject),
                                  parseJSON: { (json) -> Void in
                                    return
    },
                                  errorParseJSON: { _,_  in
                                    return "OK"
    })
  }
}

struct ClickEvent: Event, EventSync, Codable {
  
  var eventType: String
  var eventName: String
  var timestamp: TimeInterval
  var userID: String?
  
  // Either indexName or queryID with position
  var indexName: String?
  
  var queryID: String?
  var position: Int?
  
  // Either objectIDs or filterValue
  var objectIDs: [String]?
  var filterValue: String?
  
  static let EVENT_NAME = "Click"
  public init(name: String, timestamp: TimeInterval, userID: String?, indexNameOrQuery: IndexOrQuery, objectIDsOrFilterValue: ObjectIDsOrFilterValue) {
    self.eventType = ViewEvent.EVENT_NAME
    self.eventName = name
    self.timestamp = timestamp
    self.userID = userID
    indexNameOrQuery.indexOrQuery.either(ifLeft: { indexName in
      self.indexName = indexName
    }, ifRight: { queryPosition in
      self.queryID = queryPosition.0
      self.position = queryPosition.1
    })
  }
  
  func sync() -> Resource<Void, String> {
    let coder = JSONEncoder()
    let data: Data = try! coder.encode(self)
    
    return Resource<Void, String>(url: API.url(route: API.Endpoint.click),
                                  method: .post([], data as AnyObject),
                                  parseJSON: { (json) -> Void in
                                    return
    },
                                  errorParseJSON: { _,_  in
                                    return "OK"
    })
  }
}

struct ConversionEvent: EventSync {
  static let EVENT_NAME = "Click"
  static let EVENT_NAME_KEY = "eventType"
  var params: [String: Any]
  
  init(params: [String: Any]) {
    self.params = params
    self.params[ConversionEvent.EVENT_NAME_KEY] = ConversionEvent.EVENT_NAME
  }
  
  
  func sync() -> Resource<Void, String> {
    return Resource<Void, String>(url: API.url(route: API.Endpoint.conversion),
                                  method: .post([], params as AnyObject),
                                  parseJSON: { (json) -> Void in
                                    return
    },
                                  errorParseJSON: { _,_  in
                                    return "OK"
    })
  }
  
  
}

//
//  Events.swift
//  Insights
//

//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation


protocol EventSync {
  func sync() -> Resource<Bool, WebserviceError>
}

struct Event: EventSync, Codable {
  static let EVENT_TYPE_KEY = "eventType"
  let event: API.Event
  var params: [String: Any]
  
  enum CodingKeys: String, CodingKey {
    case event
    case params
  }
  
  init(params: [String: Any], event: API.Event) {
    self.params = params
    self.event = event
    self.params[Event.EVENT_TYPE_KEY] = API.Event.eventType(event: event)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.event = API.Event(rawValue: try container.decode(Int.self  , forKey: .event))!
    self.params = try container.decode([String: Any].self, forKey: .params)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.event.rawValue, forKey: .event)
    try container.encode(self.params, forKey: .params)
  }
  
  func sync() -> Resource<Bool, WebserviceError> {
    return Resource<Bool, WebserviceError>(url: API.url(route: self.event),
                                             method: .post([], params as AnyObject),
                                             allowEmptyResponse: true,
                                             errorParseJSON: { (code, data) -> WebserviceError? in
                                              if let data = data as? [String: Any],
                                                let message = data["message"] as? String{
                                                let error = WebserviceError(code: code, message: message)
                                                return error
                                              }
                                              return nil
                                            })
  }
}

extension Event: Equatable {
  static func == (lhs: Event, rhs: Event) -> Bool {
    return lhs.event == rhs.event && NSDictionary(dictionary: lhs.params).isEqual(to: rhs.params)
  }
}


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

struct Event: EventSync {
  static let EVENT_TYPE_KEY = "eventType"
  let event: API.Event
  var params: [String: Any]
  
  init(params: [String: Any], event: API.Event) {
    self.params = params
    self.event = event
    self.params[Event.EVENT_TYPE_KEY] = API.Event.eventType(event: event)
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

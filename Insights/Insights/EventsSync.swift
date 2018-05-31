//
//  EventsSync.swift
//  Insights
//

//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

class EventsSync {
  let webservice: WebService
  
  init(webservice: WebService) {
    self.webservice = webservice
  }
  
  public func syncEvent(event: EventSync, completionHandler: @escaping (Bool) -> ()) {
    webservice.load(resource: event.sync(),
                    completion: { (res) in
                      switch res {
                      case .success(_):
                        completionHandler(true)
                      case .fail(let err):
                        print(err)
                        completionHandler(false)
                      }
    })
  }
}

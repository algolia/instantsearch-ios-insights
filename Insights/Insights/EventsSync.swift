//
//  EventsSync.swift
//  Insights
//

//  Copyright © 2018 Algolia. All rights reserved.
//

import UIKit

class EventsSync {
  let webservice: WebService
  
  init(webservice: WebService) {
    self.webservice = webservice
  }
  
  public func syncEvent(event: EventSync) {
    webservice.load(resource: event.sync(),
                    completion: { (_) in
                      })
  }
}

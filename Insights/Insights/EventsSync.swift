//
//  EventsSync.swift
//  Insights
//

//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

extension WebService {
  public func sync(event: Syncable, completionHandler: @escaping (Bool) -> ()) {
    load(resource: event.sync(),
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

//
//  EventsSync.swift
//  Insights
//

//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

extension WebService {
  public func sync(_ item: Syncable, completionHandler: @escaping (Error?) -> Void) {
    load(resource: item.sync(),
         completion: { [weak self] result in
          switch result {
          case .success:
            self?.logger.debug(message: "Sync succeded for \(item)")
            completionHandler(nil)
            
          case .fail(let err):
            self?.logger.debug(message: (err as? WebserviceError)?.localizedDescription ?? err.localizedDescription)
            completionHandler(err)
          }
    })
  }
}

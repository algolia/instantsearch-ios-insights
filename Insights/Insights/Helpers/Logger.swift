//
//  Logger.swift
//  Insights
//
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

class Logger {
  
  var enabled = false
  let index: String
  
  init(_ index: String) {
    self.index = index
  }
  
  func debug(message: String) {
    if enabled {
      print("[Algolia Insights - \(index)] (\(message))")
    }
  }
}

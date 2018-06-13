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
  let outputHandler: (String) -> ()
  
  init(_ index: String, _ output:@escaping (String) -> () = dPrint) {
    self.index = index
    self.outputHandler = output
  }
  
  func debug(message: String) {
    if enabled {
      outputHandler("[Algolia Insights - \(index)] \(message)")
    }
  }
}

func dPrint(_ message: String) {
  print(message)
}

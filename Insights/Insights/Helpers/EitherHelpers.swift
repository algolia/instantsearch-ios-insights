//
//  IndexOrQuery.swift
//  Insights
//
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

@objc public class IndexOrQuery: NSObject {
  let indexOrQuery: Either<String, (String, Int)>
  
  @objc public init(indexName: String) {
    indexOrQuery = Either.left(indexName)
    super.init()
  }
  
  @objc public init(queryID: String, position: Int) {
    indexOrQuery = Either.right((queryID, position))
    super.init()
  }
}

@objc public class ObjectIDsOrFilterValue: NSObject {
  let indexOrQuery: Either<[String], String>
  
  @objc public init(objectIDs: [String]) {
    indexOrQuery = Either.left(objectIDs)
    super.init()
  }
  
  @objc public init(filterValue: String) {
    indexOrQuery = Either.right(filterValue)
    super.init()
  }
}

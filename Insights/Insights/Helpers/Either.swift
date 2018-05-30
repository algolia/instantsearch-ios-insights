//
//  Either.swift
//  Insights
//
//  Copyright © 2018 Algolia. All rights reserved.
//

import UIKit

public enum Either<T, U> {
  case left(T)
  case right(U)
}

extension Either {
  
  public func either<Result>(ifLeft: (T) throws -> Result, ifRight: (U) throws -> Result) rethrows -> Result {
    switch self {
    case let .left(x):
      return try ifLeft(x)
    case let .right(x):
      return try ifRight(x)
    }
  }
}

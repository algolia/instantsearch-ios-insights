//
//  APIEndpoint.swift
//  Insights
//

//  Copyright © 2018 Algolia. All rights reserved.
//

import UIKit

enum Environment{
  case prod
  case dev
}

let environment:Environment = {
  let e:Environment
  #if DEV
  e = Environment.dev
  #else
  e = Environment.prod
  #endif
  print("App environment \(e)")
  return e
}()


protocol APIEndpoint {
  /// server baseURL
  static var baseURL:URL {get}
  /// for api calls
  static var baseAPIURL:URL {get}
  static func url(path:String) -> URL
}

extension APIEndpoint{
  static func url(path:String) -> URL{
    return URL(string:path, relativeTo:baseAPIURL)!
  }
}

struct API {
  enum Event: Int {
    case click
    case view
    case conversion
  }
}

extension API: APIEndpoint {
  static let baseURL : URL = {
    switch environment {
    case .prod:
      return URL(string: "https://insights.algolia.io")!
    case .dev:
      return URL(string: "http://localhost:8080")!
    }
  }()
  static let baseAPIURL: URL = { return URL(string:"/1/searches/", relativeTo: baseURL)!
  }()
}

extension APIEndpoint {
  static func url(route: API.Event) -> URL{
    switch route {
    case .click:
      return url(path: "click")
    case .view:
      return url(path: "view")
    case .conversion:
      return url(path: "conversion")
    }
  }
}

extension API.Event {
  var description: String {
    switch self {
    case .click:
      return "Click"
    case .view:
      return "View"
    case .conversion:
      return "Conversion"
    }
  }
}

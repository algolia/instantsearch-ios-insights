//
//  APIEndpoint.swift
//  Insights
//

//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

enum Environment {
    case prod
    case dev
}

@objc public enum Region: Int {
    
    case us
    case de
    case auto
    
    var urlSuffix: String {
        switch self {
        case .auto:
            return ""
            
        case .us:
            return ".us"
            
        case .de:
            return ".de"
        }
    }
    
}

let environment: Environment = {
    let env: Environment
    #if DEV
    env = Environment.dev
    #else
    env = Environment.prod
    #endif
    return env
}()

protocol APIEndpoint {
  /// server baseURL
  static var baseURL: URL {get}
  /// for api calls
  static var baseAPIURL: URL {get}
  static func url(path: String) -> URL
}

extension APIEndpoint {
  static func url(path: String) -> URL {
    return URL(string: path, relativeTo: baseAPIURL)!
  }
}

struct API {
}

extension API: APIEndpoint {
  static let baseURL: URL = {
    switch environment {
    case .prod:
      return URL(string: "https://insights\(Insights.region.urlSuffix).algolia.io")!
    case .dev:
      return URL(string: "http://localhost:8080")!
    }
  }()
  static let baseAPIURL: URL = { return URL(string: "/1/events/", relativeTo: baseURL)!
  }()
}

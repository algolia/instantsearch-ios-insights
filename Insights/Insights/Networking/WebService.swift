//
//  WebService.swift
//  Insights
//

//  Copyright © 2018 Algolia. All rights reserved.
//

import UIKit

class WebService {
  static let X_APPLICATION_ID = "X-Algolia-Application-Id"
  static let X_API_KEY = "X-Algolia-API-Key"
  
  let urlSession: URLSession
  let credentials: Credentials
  
  init(credentials: Credentials) {
    let config = URLSessionConfiguration.default
    config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    config.urlCache = nil
    config.httpAdditionalHeaders = [
      WebService.X_APPLICATION_ID: credentials.appId,
      WebService.X_API_KEY: credentials.apiKey
    ]
    self.credentials = credentials
    urlSession = URLSession(configuration: config)
  }
  
  public func makeRequest<A,E>(for resource:Resource<A, E>) -> URLRequest{
    return URLRequest(resource: resource)
  }
  
  public func load<A, E>(resource: Resource<A, E>, completion: @escaping (Any) -> ()) {
    let request = makeRequest(for: resource)
    urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
      let json = try? JSONSerialization.jsonObject(with: data!, options: [])
      print(json)
      print(data)
      print(response)
      print(error)
    }).resume()
  }
}

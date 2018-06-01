//
//  WebService.swift
//  Insights
//

//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

class WebService {
  static let X_APPLICATION_ID = "X-Algolia-Application-Id"
  static let X_API_KEY = "X-Algolia-API-Key"
  
  let urlSession: URLSession
  let credentials: Credentials
  
  // TODO: the SessionConfig should be injected instead of the credentials
  init(credentials: Credentials) {
    let config = URLSessionConfiguration.default
    config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    config.urlCache = nil
    config.isDiscretionary = true
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
  
  public func load<A, E>(resource: Resource<A, E>, completion: @escaping (Result<A>) -> ()) {
    let request = makeRequest(for: resource)
    urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
      if let error  = error {
        DispatchQueue.main.async {
          completion(Result<A>.fail(error))
        }
        return
      }
      guard let response = response as? HTTPURLResponse else {
        DispatchQueue.main.async {(
          completion(Result<A>.fail(WebserviceError(code: -1, message: "Unknown response type")))
        )}
        return
      }
      if  response.statusCode == 200 || response.statusCode == 201 {
        if let parsed:A = data.flatMap(resource.parse) {
          DispatchQueue.main.async {
            completion(Result<A>.success(parsed))
          }
        } else {
          if resource.allowEmptyResponse {
            completion(Result<A>.success(nil))
          } else {
            completion(Result<A>.fail(WebserviceError(code: -1, message: "Fail to parse")))
          }
        }
      } else {
        let parsedApiError = data.flatMap({resource.errorParse(response.statusCode,$0)}) as? WebserviceError
        let error = parsedApiError ?? WebserviceError(code: -1, message: "Unknown response type")
        DispatchQueue.main.async { completion(Result<A>.fail(error)) }

      }
    }).resume()
  }
}

public protocol APIError: Error {
  var code: Int { get }
  var message: String { get }
}

public struct WebserviceError: APIError {
  public let code: Int
  public let message: String
}

//
//  Resource.swift
//  Insights
//

//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

struct Resource<A, E> where E: Error {
  let url: URL
  let method: HttpMethod<Data>
  let contentType: String
  let parse: (Data) -> A?
  let allowEmptyResponse: Bool
  let errorParse: (Int, Data) -> E?
  let aditionalHeaders: [String: String]
}

extension Resource {
  
  init(url: URL, method: HttpMethod<AnyObject> = .get([]), contentType: String = "application/json", parseJSON: @escaping (Any) -> A? = { _ in return nil}, allowEmptyResponse: Bool = false, errorParseJSON: @escaping (Int, Any) -> E? = {_, _ in return nil}, aditionalHeaders: [String: String] = [:]) {
    self.allowEmptyResponse = allowEmptyResponse
    self.url = url
    self.method =  method.map { json in
        switch json {
        case let data as Data:
            return data
        case let dictionary as [String: AnyObject]:
            if let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) {
                return data
            } else {
                fallthrough
            }
        default:
            return Data()
        }
    }
    
    self.parse = { data in
      let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
      return json.flatMap(parseJSON)
    }
    self.contentType = contentType
    self.errorParse = {status, data in
      let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
      return json.flatMap({errorParseJSON(status, $0)})
    }
    self.aditionalHeaders = aditionalHeaders
  }
}

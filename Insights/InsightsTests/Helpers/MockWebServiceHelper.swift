//
//  HelperMockWS.swift
//  InsightsTests
//
//  Created by Robert Mogos on 12/06/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation
@testable import Insights

@objc public class MockWebServiceHelper: NSObject {
  static public func getMockWebService(indexName: String, _ stub: @escaping (Any) -> ()) -> WebService {
    let logger = Logger(indexName)
    let mockWS = MockWebService(sessionConfig: Algolia.SessionConfig.default(appId: "dummyAppId",
                                                                     apiKey: "dummyApiKey"),
                        logger: logger,
                        stub: stub)
    return mockWS
  }
  
  @objc static public func getMockInsights(indexName: String, _ stub: @escaping (Any) -> ()) -> Insights {
    let insightsRegister = Insights(credentials: Credentials(appId: "dummyAppId",
                                                             apiKey: "dummyApiKey",
                                                             indexName: indexName),
                                    webService: getMockWebService(indexName: indexName, stub),
                                    flushDelay: 10,
                                    logger: Logger(indexName))
    return insightsRegister
  }
}

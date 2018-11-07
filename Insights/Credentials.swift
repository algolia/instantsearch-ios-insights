//
//  Credentials.swift
//  Insights
//
//  Created by Vladislav Fitc on 07/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

@objcMembers public class Credentials: NSObject {
    
    let appId: String
    let apiKey: String
    let indexName: String
    
    init(appId: String, apiKey: String, indexName: String) {
        self.appId = appId
        self.apiKey = apiKey
        self.indexName = indexName
        super.init()
    }
}

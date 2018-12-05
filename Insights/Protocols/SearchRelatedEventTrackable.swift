//
//  SearchRelatedEventTrackable.swift
//  Insights
//
//  Created by Vladislav Fitc on 05/12/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

protocol SearchRelatedEventTrackable {
    
    func click(queryID: String, userToken: String?,
               indexName: String,
               timestamp: Int64,
               objectIDsWithPositions: [(String, Int)])
    
    func click(queryID: String, userToken: String?,
               indexName: String,
               timestamp: Int64,
               objectIDs: [String],
               positions: [Int])
    
    func conversion(queryID: String,
                    userToken: String?,
                    indexName: String,
                    timestamp: Int64,
                    objectIDs: [String])
    
}

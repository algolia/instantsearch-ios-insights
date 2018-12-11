//
//  SearchEventTrackable.swift
//  Insights
//
//  Created by Vladislav Fitc on 05/12/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

protocol SearchEventTrackable {
    
    func click(queryID: String,
               indexName: String,
               userToken: String?,
               timestamp: Int64,
               objectIDsWithPositions: [(String, Int)])
        
    func conversion(queryID: String,
                    indexName: String,
                    userToken: String?,
                    timestamp: Int64,
                    objectIDs: [String])
    
}

//
//  CustomEventTrackable.swift
//  Insights
//
//  Created by Vladislav Fitc on 05/12/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

protocol CustomEventTrackable {
    
    func view(eventName: String,
              indexName: String,
              userToken: String?,
              timestamp: Int64,
              objectIDs: [String])
    
    func view(eventName: String,
              indexName: String,
              userToken: String?,
              timestamp: Int64,
              filters: [String])
    
    func click(eventName: String,
               indexName: String,
               userToken: String?,
               timestamp: Int64,
               objectIDs: [String])
    
    func click(eventName: String,
               indexName: String,
               userToken: String?,
               timestamp: Int64,
               filters: [String])
    
    func conversion(eventName: String,
                    indexName: String,
                    userToken: String?,
                    timestamp: Int64,
                    objectIDs: [String])
    
    func conversion(eventName: String,
                    indexName: String,
                    userToken: String?,
                    timestamp: Int64,
                    filters: [String])
    
}

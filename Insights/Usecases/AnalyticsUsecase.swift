//
//  AnalyticsUsecase.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

protocol AnalyticsUsecase {
    
    var eventProcessor: EventProcessable { get }
    var logger: Logger { get }
    
}

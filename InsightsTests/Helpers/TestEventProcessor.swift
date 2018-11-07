//
//  TestEventProcessor.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 07/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchInsights

class TestEventProcessor: EventProcessor {
    
    var didProcess: (Event) -> Void = { _ in }
    
    func process(_ event: Event) {
        didProcess(event)
    }
    
}

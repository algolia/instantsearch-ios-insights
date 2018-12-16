//
//  TimerControllerTests.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 16/12/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import XCTest
@testable import InstantSearchInsights

class TimerControllerTests: XCTestCase {
    
    func testInit() {
        let timerController = TimerController(delay: 10)
        XCTAssertEqual(timerController.delay, 10)
        XCTAssertFalse(timerController.isActive)
        XCTAssertNil(timerController.action)
    }
    
    func testAction() {
        let exp = expectation(description: "timer action")
        let timerController = TimerController(delay: 1)
        timerController.setup()
        XCTAssertTrue(timerController.isActive)
        timerController.action = {
            exp.fulfill()
            timerController.invalidate()
        }
        wait(for: [exp], timeout: 5)
    }
    
    func testInvalidation() {
        let exp = expectation(description: "timer action")
        exp.isInverted = true
        let timerController = TimerController(delay: 1)
        timerController.action = {
            exp.fulfill()
        }
        timerController.setup()
        XCTAssertTrue(timerController.isActive)
        timerController.invalidate()
        XCTAssertFalse(timerController.isActive)
        wait(for: [exp], timeout: 5)
    }
    
    func testChangeDelay() {
        let exp = expectation(description: "timer action")
        let timerController = TimerController(delay: 1)
        timerController.action = {
            exp.fulfill()
            timerController.invalidate()
        }
        XCTAssertFalse(timerController.isActive)
        timerController.delay = 2
        XCTAssertEqual(timerController.delay, 2)
        XCTAssertFalse(timerController.isActive)
        timerController.setup()
        timerController.delay = 3
        XCTAssertEqual(timerController.delay, 3)
        XCTAssertTrue(timerController.isActive)
        wait(for: [exp], timeout: 5)
    }
    
}

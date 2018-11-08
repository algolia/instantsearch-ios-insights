//
//  InsightsTestObjC.m
//  InsightsTests
//
//  Copyright © 2018 Algolia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "InsightsTests-Swift.h"
@import Foundation;
@import InstantSearchInsights;

@interface InsightsTestObjC : XCTestCase

@end

@implementation InsightsTestObjC

XCTestExpectation* expectation;
Insights *stubInsights;

- (void)setUp {
    stubInsights = [MockWebServiceHelper getMockInsightsWithIndexName:@"indexName" :^(id res) {
        XCTAssertNotNil(res);
        [expectation fulfill];
    }];
}

- (void)testInitShouldWork {
  NSString* indexName = @"testIndex";
  Insights* insightsRegister = [Insights registerWithAppId:@"testApp"
                                                    apiKey:@"testKey"
                                                 indexName:indexName];
  
  XCTAssertNotNil(insightsRegister);
  XCTAssertNotNil([Insights sharedWithIndex:indexName]);
}

- (void)testInitShouldFail {
  XCTAssertNil([Insights sharedWithIndex:@"notRegisteredIndex"]);
}

- (void) testClickAnalyticsClick {
    NSError * e;
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    expectation = [self expectationWithDescription:@"waitForCompletion"];
    [[stubInsights clickAnalytics] clickWithUserToken:@""
                                            timestamp:timestamp
                                              queryID:@""
                                            objectIDs:@[]
                                            positions:@[]
                                                error:&e];
    [self waitForExpectations:@[expectation] timeout:2];
}

- (void) testClickAnalyticsConversion {
    NSError * e;
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    expectation = [self expectationWithDescription:@"waitForCompletion"];
    [[stubInsights clickAnalytics] conversionWithUserToken:@""
                                                 timestamp:timestamp
                                                   queryID:@""
                                                 objectIDs:@[]
                                                     error:&e];
    [self waitForExpectations:@[expectation] timeout:2];
}

- (void) testABTestingClick {
    NSError * e;
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    expectation = [self expectationWithDescription:@"waitForCompletion"];
    [[stubInsights abTesting] clickWithUserToken:@""
                                       timestamp:timestamp
                                         queryID:@""
                                       objectIDs:@[]
                                       positions:@[]
                                           error:&e];
    [self waitForExpectations:@[expectation] timeout:2];
}

- (void) testABTestingConversion {
    NSError * e;
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    expectation = [self expectationWithDescription:@"waitForCompletion"];
    [[stubInsights abTesting] conversionWithUserToken:@""
                                            timestamp:timestamp
                                              queryID:@""
                                            objectIDs:@[]
                                                error:&e];
    [self waitForExpectations:@[expectation] timeout:2];
}

- (void) testPersonalizationClick {
    NSError * e;
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    expectation = [self expectationWithDescription:@"waitForCompletion"];
    [[stubInsights personalization] clickWithEventName:@""
                                             userToken:@""
                                             timestamp:timestamp
                                             objectIDs:@[]
                                                 error:&e];
    [self waitForExpectations:@[expectation] timeout:2];
}

- (void) testPersonalizationView {
    NSError * e;
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    expectation = [self expectationWithDescription:@"waitForCompletion"];
    [[stubInsights personalization] viewWithEventName:@""
                                            userToken:@""
                                            timestamp:timestamp
                                            objectIDs:@[]
                                                error:&e];
    [self waitForExpectations:@[expectation] timeout:2];
}

- (void) testPersonalizationConversion {
    NSError * e;
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    expectation = [self expectationWithDescription:@"waitForCompletion"];
    [[stubInsights personalization] conversionWithEventName:@""
                                                  userToken:@""
                                                  timestamp:timestamp
                                                  objectIDs:@[]
                                                      error:&e];
    [self waitForExpectations:@[expectation] timeout:2];
}
 
@end

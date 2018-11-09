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
//    expectation = [self expectationWithDescription:@"waitForCompletion"];
//    [expectation setExpectedFulfillmentCount:7];
    stubInsights = [MockWebServiceHelper getMockInsightsWithAppId:@"indexName" :^(id res) {
        XCTAssertNotNil(res);
//        [expectation fulfill];
    }];
}

- (void)testInitShouldWork {
  NSString* appId = @"testApp";
  Insights* insightsRegister = [Insights registerWithAppId:appId
                                                    apiKey:@"testKey"];
  
  XCTAssertNotNil(insightsRegister);
  XCTAssertNotNil([Insights sharedWithAppId:appId]);
}

- (void)testInitShouldFail {
  XCTAssertNil([Insights sharedWithAppId:@"notRegisteredIndex"]);
}

- (void) testClickAnalyticsClick {
    NSError * e;
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights clickAnalytics] clickWithUserToken:@""
                                            indexName:@""
                                            timestamp:timestamp
                                              queryID:@""
                                            objectIDs:@[]
                                            positions:@[]
                                                error:&e];
//    [self waitForExpectations:@[expectation] timeout:2];
}

- (void) testClickAnalyticsConversion {
    NSError * e;
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights clickAnalytics] conversionWithUserToken:@""
                                                 indexName:@""
                                                 timestamp:timestamp
                                                   queryID:@""
                                                 objectIDs:@[]
                                                     error:&e];
//    [self waitForExpectations:@[expectation] timeout:2];
}

- (void) testABTestingClick {
    NSError * e;
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights abTesting] clickWithUserToken:@""
                                       indexName:@""
                                       timestamp:timestamp
                                         queryID:@""
                                       objectIDs:@[]
                                       positions:@[]
                                           error:&e];
//    [self waitForExpectations:@[expectation] timeout:2];
}

- (void) testABTestingConversion {
    NSError * e;
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights abTesting] conversionWithUserToken:@""
                                            indexName:@""
                                            timestamp:timestamp
                                              queryID:@""
                                            objectIDs:@[]
                                                error:&e];
//    [self waitForExpectations:@[expectation] timeout:2];
}

- (void) testPersonalizationClick {
    NSError * e;
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights personalization] clickWithEventName:@""
                                             indexName:@""
                                             userToken:@""
                                             timestamp:timestamp
                                             objectIDs:@[]
                                                 error:&e];
//    [self waitForExpectations:@[expectation] timeout:2];
}

- (void) testPersonalizationView {
    NSError * e;
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights personalization] viewWithEventName:@""
                                            indexName:@""
                                            userToken:@""
                                            timestamp:timestamp
                                            objectIDs:@[]
                                                error:&e];
//    [self waitForExpectations:@[expectation] timeout:2];
}

- (void) testPersonalizationConversion {
    NSError * e;
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights personalization] conversionWithEventName:@""
                                                  indexName:@""
                                                  userToken:@""
                                                  timestamp:timestamp
                                                  objectIDs:@[]
                                                      error:&e];
//    [self waitForExpectations:@[expectation] timeout:2];
}
 
@end

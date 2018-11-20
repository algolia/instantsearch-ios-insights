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
    stubInsights = [MockWebServiceHelper getMockInsightsWithAppId:@"indexName" :^(id res) {
        XCTAssertNotNil(res);
    }];
}

- (void)testInitShouldWork {
  NSString* appId = @"testApp";
  Insights* insightsRegister = [Insights registerWithAppId:appId
                                                    apiKey:@"testKey"];
  
  [Insights setRegion:RegionDe];
  [Insights setRegion:RegionAuto];
  XCTAssertNotNil(insightsRegister);
  XCTAssertNotNil([Insights sharedWithAppId:appId]);
    
    
    [[[Insights shared] clickAnalytics] clickWithUserToken:@"user token"
                                                 indexName:@"my index"
                                                 timestamp:[[NSDate new] timeIntervalSince1970]
                                                   queryID:@"q123"
                                                 objectIDs:@[@"obj1", @"obj2"]
                                                 positions:@[@1, @2]];
    
    [[[Insights shared] abTesting] conversionWithUserToken:@"user token"
                                                 indexName:@"my index"
                                                 timestamp:[[NSDate new] timeIntervalSince1970]
                                                   queryID:@"q123"
                                                 objectIDs:@[@"obj1", @"obj2"]];
    
    [[[Insights shared] personalization] viewWithEventName:@"View event"
                                                 indexName:@"my index"
                                                 userToken:@"user token"
                                                 timestamp:[[NSDate new] timeIntervalSince1970]
                                                   filters:@[@"brand:apple"]];
    
    [[[Insights sharedWithAppId:@"app id"] clickAnalytics] clickWithUserToken:@"user token"
                                                                    indexName:@"my index"
                                                                    timestamp:[[NSDate new] timeIntervalSince1970]
                                                                      queryID:@"q123"
                                                                    objectIDs:@[@"obj1", @"obj2"]
                                                                    positions:@[@1, @2]];

}

- (void)testInitShouldFail {
  XCTAssertNil([Insights sharedWithAppId:@"notRegisteredIndex"]);
}

- (void) testClickAnalyticsClick {
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights clickAnalytics] clickWithUserToken:@""
                                            indexName:@""
                                            timestamp:timestamp
                                              queryID:@""
                                            objectIDs:@[]
                                            positions:@[]];
}

- (void) testClickAnalyticsConversion {
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights clickAnalytics] conversionWithUserToken:@""
                                                 indexName:@""
                                                 timestamp:timestamp
                                                   queryID:@""
                                                 objectIDs:@[]];
}

- (void) testABTestingClick {
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights abTesting] clickWithUserToken:@""
                                       indexName:@""
                                       timestamp:timestamp
                                         queryID:@""
                                       objectIDs:@[]
                                       positions:@[]];
}

- (void) testABTestingConversion {
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights abTesting] conversionWithUserToken:@""
                                            indexName:@""
                                            timestamp:timestamp
                                              queryID:@""
                                            objectIDs:@[]];
}

- (void) testPersonalizationClick {
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights personalization] clickWithEventName:@""
                                             indexName:@""
                                             userToken:@""
                                             timestamp:timestamp
                                             objectIDs:@[]];
}

- (void) testPersonalizationView {
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights personalization] viewWithEventName:@""
                                            indexName:@""
                                            userToken:@""
                                            timestamp:timestamp
                                            objectIDs:@[]];
}

- (void) testPersonalizationConversion {
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights personalization] conversionWithEventName:@""
                                                  indexName:@""
                                                  userToken:@""
                                                  timestamp:timestamp
                                                  objectIDs:@[]];
}
 
@end

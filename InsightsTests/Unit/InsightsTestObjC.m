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
}
 
@end

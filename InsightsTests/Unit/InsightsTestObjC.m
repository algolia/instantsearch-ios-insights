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
                                                    apiKey:@"testKey"
                                                 userToken:@"user token"];
  
  [Insights setRegion:[Region us]];
  [Insights setRegion:nil];
  XCTAssertNotNil(insightsRegister);
  XCTAssertNotNil([Insights sharedWithAppId:appId]);
    
    
    [[[Insights shared] search] clickWithUserToken:@"user token"
                                         indexName:@"my index"
                                         timestamp:[[NSDate new] timeIntervalSince1970]
                                           queryID:@"q123"
                                         objectIDs:@[@"obj1", @"obj2"]
                                         positions:@[@1, @2]];

    [[[Insights shared] search] conversionWithUserToken:@"user token"
                                              indexName:@"my index"
                                              timestamp:[[NSDate new] timeIntervalSince1970]
                                                queryID:@"q123"
                                              objectIDs:@[@"obj1", @"obj2"]];

    [[[Insights shared] visit] viewWithEventName:@"View event"
                                       indexName:@"my index"
                                       userToken:@"user token"
                                       timestamp:[[NSDate new] timeIntervalSince1970]
                                         filters:@[@"brand:apple"]];

    [[[Insights sharedWithAppId:@"app id"] search] clickWithUserToken:@"user token"
                                                            indexName:@"my index"
                                                            timestamp:[[NSDate new] timeIntervalSince1970]
                                                              queryID:@"q123"
                                                            objectIDs:@[@"obj1", @"obj2"]
                                                            positions:@[@1, @2]];

}

- (void)testInitShouldFail {
  XCTAssertNil([Insights sharedWithAppId:@"notRegisteredIndex"]);
}

- (void) testSearchClick {
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights search] clickWithUserToken:@""
                                            indexName:@""
                                            timestamp:timestamp
                                              queryID:@""
                                            objectIDs:@[]
                                            positions:@[]];
}

- (void) testSearchConversion {
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights search] conversionWithUserToken:@""
                                                 indexName:@""
                                                 timestamp:timestamp
                                                   queryID:@""
                                                 objectIDs:@[]];
}
 
- (void) testVisitClick {
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights visit] clickWithEventName:@""
                                             indexName:@""
                                             userToken:@""
                                             timestamp:timestamp
                                             objectIDs:@[]];
}

- (void) testVisitView {
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights visit] viewWithEventName:@""
                                            indexName:@""
                                            userToken:@""
                                            timestamp:timestamp
                                            objectIDs:@[]];
}

- (void) testVisitConversion {
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [[stubInsights visit] conversionWithEventName:@""
                                                  indexName:@""
                                                  userToken:@""
                                                  timestamp:timestamp
                                                  objectIDs:@[]];
}
 
@end

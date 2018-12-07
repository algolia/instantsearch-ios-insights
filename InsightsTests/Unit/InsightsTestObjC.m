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
    
    [[Insights shared] clickAfterSearchWithQueryID:@"q123"
                                         indexName:@"my index"
                                         userToken:@"user token"
                                         timestamp:[[NSDate new] timeIntervalSince1970]
                                         objectIDs:@[@"obj1", @"obj2"]
                                         positions:@[@1, @2]];
    
    [[Insights shared] conversionAfterSearchWithQueryID:@"q123"
                                              indexName:@"my index"
                                              userToken:@"user token"
                                              timestamp:[[NSDate new] timeIntervalSince1970]
                                              objectIDs:@[@"obj1", @"obj2"]];
    
    [[Insights shared] viewWithEventName:@"View event"
                               indexName:@"my index"
                               userToken:@"user token"
                               timestamp:[[NSDate new] timeIntervalSince1970]
                                 filters:@[@"brand:apple"]];
    
    [[Insights sharedWithAppId:@"app id"] clickAfterSearchWithQueryID:@"q123"
                                                            indexName:@"my index"
                                                            userToken:@"user token"
                                                            timestamp:[[NSDate new] timeIntervalSince1970]
                                                            objectIDs:@[@"obj1", @"obj2"]
                                                            positions:@[@1, @2]];
    
}

- (void)testInitShouldFail {
    XCTAssertNil([Insights sharedWithAppId:@"notRegisteredIndex"]);
}

- (void) testSearchClick {
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [stubInsights clickAfterSearchWithQueryID:@""
                                    indexName:@""
                                    userToken:@""
                                    timestamp:timestamp
                                    objectIDs:@[]
                                    positions:@[]];
}

- (void) testSearchConversion {
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [stubInsights conversionAfterSearchWithQueryID:@""
                                         indexName:@""
                                         userToken:@""
                                         timestamp:timestamp
                                         objectIDs:@[]];
}

- (void) testVisitClick {
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [stubInsights clickWithEventName:@""
                           indexName:@""
                           userToken:@""
                           timestamp:timestamp
                           objectIDs:@[]];
}

- (void) testVisitView {
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [stubInsights viewWithEventName:@""
                          indexName:@""
                          userToken:@""
                          timestamp:timestamp
                          objectIDs:@[]];
}

- (void) testVisitConversion {
    NSTimeInterval timestamp = NSDate.new.timeIntervalSince1970;
    [stubInsights conversionWithEventName:@""
                                indexName:@""
                                userToken:@""
                                timestamp:timestamp
                                objectIDs:@[]];
}
 
@end

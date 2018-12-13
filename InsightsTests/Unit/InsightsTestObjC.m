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
    
    [[Insights shared] clickAfterSearchWithEventName:@"click event"
                                           indexName:@"my index"
                                           objectIDs:@[@"o1", @"o2"]
                                           positions:@[@1, @2]
                                             queryID:@"q123"
                                           userToken:@"user token"];
    
    [[Insights shared] conversionAfterSearchWithEventName:@"conversion event"
                                                indexName:@"my index"
                                                objectIDs:@[@"o1", @"o2"]
                                                  queryID:@"q123"
                                                userToken:@"user token"];
    
    [[Insights shared] viewWithEventName:@"view event"
                               indexName:@"my index"
                                 filters:@[@"brand:apple"]
                               userToken:@"user token"];
    
    [[Insights sharedWithAppId:@"app id"] clickAfterSearchWithEventName:@"event name" \
                                                              indexName:@"my inde"
                                                              objectIDs:@[@"o1", @"o2"]
                                                              positions:@[@1, @2]
                                                                queryID:@"q123"
                                                              userToken:@"user token"];
    
}

- (void)testInitShouldFail {
    XCTAssertNil([Insights sharedWithAppId:@"notRegisteredIndex"]);
}

- (void) testSearchClick {
    [stubInsights clickAfterSearchWithEventName:@""
                                      indexName:@""
                                       objectID:@""
                                       position:1
                                        queryID:@""
                                      userToken:@""];
    
    [stubInsights clickAfterSearchWithEventName:@""
                                      indexName:@""
                                      objectIDs:@[@"o1"]
                                      positions:@[@1]
                                        queryID:@""
                                      userToken:nil];
}

- (void) testSearchConversion {
    [stubInsights conversionAfterSearchWithEventName:@""
                                           indexName:@""
                                            objectID:@""
                                             queryID:@""
                                           userToken:@""];
    
    [stubInsights conversionAfterSearchWithEventName:@""
                                           indexName:@""
                                           objectIDs:@[]
                                             queryID:@""
                                           userToken:nil];
}

- (void) testVisitClick {
    [stubInsights clickWithEventName:@""
                           indexName:@""
                           objectIDs:@[]
                           userToken:@""];
    
    [stubInsights clickWithEventName:@""
                           indexName:@""
                            objectID:@""
                           userToken:nil];
    
    [stubInsights clickWithEventName:@""
                           indexName:@""
                             filters:@[]
                           userToken:nil];

}

- (void) testVisitView {
    [stubInsights viewWithEventName:@""
                          indexName:@""
                          objectIDs:@[]
                          userToken:@""];
    
    [stubInsights viewWithEventName:@""
                          indexName:@""
                           objectID:@""
                          userToken:nil];
    
    [stubInsights viewWithEventName:@""
                          indexName:@""
                            filters:@[]
                          userToken:nil];
}

- (void) testVisitConversion {
    [stubInsights conversionWithEventName:@""
                                indexName:@""
                                objectIDs:@[]
                                userToken:@""];

    [stubInsights conversionWithEventName:@""
                                indexName:@""
                                objectID:@""
                                userToken:nil];
    
    [stubInsights conversionWithEventName:@""
                                indexName:@""
                                  filters:@[]
                                userToken:nil];
}
 
@end

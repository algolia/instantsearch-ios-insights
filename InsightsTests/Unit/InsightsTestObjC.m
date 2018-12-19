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
    
    [[Insights shared] clickedAfterSearchWithEventName:@"click event"
                                           indexName:@"my index"
                                           objectIDs:@[@"o1", @"o2"]
                                           positions:@[@1, @2]
                                             queryID:@"q123"
                                           userToken:@"user token"];
    
    [[Insights shared] convertedAfterSearchWithEventName:@"conversion event"
                                                indexName:@"my index"
                                                objectIDs:@[@"o1", @"o2"]
                                                  queryID:@"q123"
                                                userToken:@"user token"];
    
    [[Insights shared] viewedWithEventName:@"view event"
                               indexName:@"my index"
                                 filters:@[@"brand:apple"]
                               userToken:@"user token"];
    
    [[Insights sharedWithAppId:@"app id"] clickedAfterSearchWithEventName:@"event name" \
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
    [stubInsights clickedAfterSearchWithEventName:@""
                                      indexName:@""
                                       objectID:@""
                                       position:1
                                        queryID:@""
                                      userToken:@""];
    
    [stubInsights clickedAfterSearchWithEventName:@""
                                      indexName:@""
                                      objectIDs:@[@"o1"]
                                      positions:@[@1]
                                        queryID:@""
                                      userToken:nil];
}

- (void) testSearchConversion {
    [stubInsights convertedAfterSearchWithEventName:@""
                                           indexName:@""
                                            objectID:@""
                                             queryID:@""
                                           userToken:@""];
    
    [stubInsights convertedAfterSearchWithEventName:@""
                                           indexName:@""
                                           objectIDs:@[]
                                             queryID:@""
                                           userToken:nil];
}

- (void) testVisitClick {
    [stubInsights clickedWithEventName:@""
                           indexName:@""
                           objectIDs:@[]
                           userToken:@""];
    
    [stubInsights clickedWithEventName:@""
                           indexName:@""
                            objectID:@""
                           userToken:nil];
    
    [stubInsights clickedWithEventName:@""
                           indexName:@""
                             filters:@[]
                           userToken:nil];

}

- (void) testVisitView {
    [stubInsights viewedWithEventName:@""
                          indexName:@""
                          objectIDs:@[]
                          userToken:@""];
    
    [stubInsights viewedWithEventName:@""
                          indexName:@""
                           objectID:@""
                          userToken:nil];
    
    [stubInsights viewedWithEventName:@""
                          indexName:@""
                            filters:@[]
                          userToken:nil];
}

- (void) testVisitConversion {
    [stubInsights convertedWithEventName:@""
                                indexName:@""
                                objectIDs:@[]
                                userToken:@""];

    [stubInsights convertedWithEventName:@""
                                indexName:@""
                                objectID:@""
                                userToken:nil];
    
    [stubInsights convertedWithEventName:@""
                                indexName:@""
                                  filters:@[]
                                userToken:nil];
}
 
@end

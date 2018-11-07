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
/* Out of scope for now


- (void) testClickEvent {
  XCTestExpectation* expectation = [self expectationWithDescription:@"waitForCompletion"];
  Insights *stubInsights = [MockWebServiceHelper getMockInsightsWithIndexName:@"indexName" :^(id res) {
    XCTAssertNotNil(res);
    [expectation fulfill];
  }];
  [stubInsights clickWithParams:@{
                                  @"a": @"b"
                                  }];
  [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void) testConversionEvent {
  XCTestExpectation* expectation = [self expectationWithDescription:@"waitForCompletion"];
  Insights *stubInsights = [MockWebServiceHelper getMockInsightsWithIndexName:@"indexName" :^(id res) {
    XCTAssertNotNil(res);
    [expectation fulfill];
  }];
  [stubInsights conversionWithParams:@{
                                  @"a": @"b"
                                  }];
  [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void) testViewEvent {
  XCTestExpectation* expectation = [self expectationWithDescription:@"waitForCompletion"];
  Insights *stubInsights = [MockWebServiceHelper getMockInsightsWithIndexName:@"indexName" :^(id res) {
    XCTAssertNotNil(res);
    [expectation fulfill];
  }];
  [stubInsights viewWithParams:@{
                                       @"a": @"b"
                                       }];
  [self waitForExpectationsWithTimeout:2 handler:nil];
}
*/
@end

//
//  InsightsTestObjC.m
//  InsightsTests
//
//  Copyright © 2018 Algolia. All rights reserved.
//

#import <XCTest/XCTest.h>
@import Insights;

@interface InsightsTestObjC : XCTestCase

@end

@implementation InsightsTestObjC

- (void)testInitShouldWork {
  NSString* indexName = @"testIndex";
  Insights* insightsRegister = [Insights registerWithAppId:@"testApp"
                                                    apiKey:@"testKey"
                                                 indexName:indexName];
  
  XCTAssertNotNil(insightsRegister);
  XCTAssertNotNil([Insights sharedWithIndex:indexName error:nil]);
}

- (void)testInitShouldFail {
  NSError *err;
  [Insights sharedWithIndex:@"notRegisteredIndex"
                      error:&err];
  XCTAssertNotNil(err);
}
@end

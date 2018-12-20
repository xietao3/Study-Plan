//
//  TTAsyncTests.m
//  TestingTutorialTests
//
//  Created by xietao on 2018/12/8.
//  Copyright © 2018 com.fruitday. All rights reserved.
//

#import "TTTestCase.h"
#import "TTFakeNetworking.h"
#import "TTConstant.h"

@interface TTAsyncTests : TTTestCase

@end

@implementation TTAsyncTests

- (void)testAsyncRequest1 {

    [XCTContext runActivityNamed:@"step1" block:^(id<XCTActivity>  _Nonnull activity) {
        XCTestExpectation *expect1 = [self expectationWithDescription:@"asyncTest1"];

        [TTFakeNetworkingInstance requestWithService:apiRecordSave completionHandler:^(NSDictionary *response) {
            XCTAssertTrue([response[@"code"] isEqualToString:@"300"]);
            [expect1 fulfill];
        }];
        
    }];
    [XCTContext runActivityNamed:@"step2" block:^(id<XCTActivity>  _Nonnull activity) {
        XCTestExpectation *expect2 = [self expectationWithDescription:@"asyncTest2"];

        [TTFakeNetworkingInstance requestWithService:apiRecordDelete completionHandler:^(NSDictionary *response) {
            XCTAssertTrue([response[@"code"] isEqualToString:@"300"]);
            [expect2 fulfill];
        }];
        
        [XCTContext runActivityNamed:@"step3" block:^(id<XCTActivity>  _Nonnull activity) {
        }];
        
    }];

    [self waitShortTimeForExpectations];

}

- (void)testAsyncRequest2 {
    XCTestExpectation *expect3 = [[XCTestExpectation alloc] initWithDescription:@"asyncTest3"];
    
    [TTFakeNetworkingInstance requestWithService:apiRecordList completionHandler:^(NSDictionary *response) {
        XCTAssertTrue([response[@"code"] isEqualToString:@"200"]);
        [expect3 fulfill];
    }];
    
    [self waitShortTimeForExpectations:@[expect3]];

}

- (void)testAsyncRequest3 {
    XCTWaiter *waiter = [[XCTWaiter alloc] initWithDelegate:self];
    XCTestExpectation *expect4 = [[XCTestExpectation alloc] initWithDescription:@"asyncTest3"];
    
    [TTFakeNetworkingInstance requestWithService:@"product.list" completionHandler:^(NSDictionary *response) {
        XCTAssertTrue([response[@"code"] isEqualToString:@"200"]);
        [expect4 fulfill];
    }];

    XCTWaiterResult result = [waiter waitForExpectations:@[expect4] timeout:10 enforceOrder:NO];
    XCTAssert(result == XCTWaiterResultCompleted, @"failed: %ld", (long)result);
}

@end

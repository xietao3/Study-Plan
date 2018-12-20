//
//  TTMultiAppTests.m
//  TestingTutorialUITests
//
//  Created by xietao on 2018/12/18.
//  Copyright © 2018 com.fruitday. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TTTestCase.h"

@interface TTMultiAppTests : TTTestCase

@end

@implementation TTMultiAppTests

- (void)setUp {
    self.continueAfterFailure = NO;

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    XCUIApplication *ttApp = [[XCUIApplication alloc] init];
    XCUIApplication *anotherApp = [[XCUIApplication alloc] initWithBundleIdentifier:@"Another.App.BundleId"];

    [ttApp launch];
    
    XCUIElement *addButton = ttApp.navigationBars[@"Record List"].buttons[@"Add"];
    [addButton tap];

        
    [anotherApp activate];
}

@end

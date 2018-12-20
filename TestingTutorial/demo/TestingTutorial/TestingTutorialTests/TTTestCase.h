//
//  TTTestCase.h
//  TestingTutorialTests
//
//  Created by xietao on 2018/12/7.
//  Copyright © 2018 com.fruitday. All rights reserved.
//

#import <XCTest/XCTest.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTTestCase : XCTestCase

- (void)waitShortTimeForExpectations;

- (void)waitLongTimeForExpectations;

- (void)waitShortTimeForExpectations:(NSArray<XCTestExpectation *> *)expectations;

- (void)waitLongTimeForExpectations:(NSArray<XCTestExpectation *> *)expectations;

- (void)addAttachmentWithScreenshot:(XCUIScreenshot *)screenshot attachmentName:(NSString *)attachmentName;
@end

NS_ASSUME_NONNULL_END

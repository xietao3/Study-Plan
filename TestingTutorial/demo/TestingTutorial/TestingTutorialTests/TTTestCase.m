//
//  TTTestCase.m
//  TestingTutorialTests
//
//  Created by xietao on 2018/12/7.
//  Copyright © 2018 com.fruitday. All rights reserved.
//

#import "TTTestCase.h"

@interface TTTestCase()

@property (nonatomic, assign) NSTimeInterval shortTime;
@property (nonatomic, assign) NSTimeInterval longTime;

@end

@implementation TTTestCase

- (void)setUp {
    self.shortTime = 10;
    self.longTime = 30;
}

- (void)waitShortTimeForExpectations {
    [self waitForExpectationsWithTimeout:self.shortTime handler:nil];
}

- (void)waitLongTimeForExpectations {
    [self waitForExpectationsWithTimeout:self.longTime handler:nil];
}

- (void)waitShortTimeForExpectations:(NSArray<XCTestExpectation *> *)expectations {
    [self waitForExpectations:expectations timeout:self.shortTime];
}

- (void)waitLongTimeForExpectations:(NSArray<XCTestExpectation *> *)expectations {
    [self waitForExpectations:expectations timeout:self.longTime];
}

- (void)addAttachmentWithScreenshot:(XCUIScreenshot *)screenshot attachmentName:(NSString *)attachmentName {
    XCTAttachment *attachment = [XCTAttachment attachmentWithScreenshot:screenshot];
    attachment.lifetime = XCTAttachmentLifetimeKeepAlways;
    attachment.name = attachmentName;
    [self addAttachment:attachment];
}

@end

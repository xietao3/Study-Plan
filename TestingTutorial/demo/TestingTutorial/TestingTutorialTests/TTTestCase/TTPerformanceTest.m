//
//  TTPerformanceTest.m
//  TestingTutorialTests
//
//  Created by xietao on 2018/12/7.
//  Copyright © 2018 com.fruitday. All rights reserved.
//

#import "TTTestCase.h"

@interface TTPerformanceTest : TTTestCase

@end

@implementation TTPerformanceTest

- (void)testSomePerformance {
    [self measureBlock:^{
        sleep(1);
    }];
}

- (void)testNoBaseline {
    [self measureBlock:^{
        sleep(1);
    }];
}

@end

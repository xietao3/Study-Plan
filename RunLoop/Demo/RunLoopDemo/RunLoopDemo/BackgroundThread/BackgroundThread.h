//
//  BackgroundThread.h
//  RunLoopDemo
//
//  Created by xietao on 2019/4/27.
//  Copyright © 2019 com.fruitday. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static  NSString * const kBackgroundThreadSourceKey = @"kBackgroundThreadSourceKey";
static  NSString * const kBackgroundThreadSourceKey1 = @"kBackgroundThreadSourceKey1";
static  NSString * const kBackgroundThreadPortKey = @"kBackgroundThreadPortKey";


@interface BackgroundThread : NSObject

@property (nonatomic, strong) NSThread *backgroundThread;
@property (nonatomic, strong) NSRunLoop *runLoop;

+ (instancetype)shareInstance;

+ (void)start;

@end

NS_ASSUME_NONNULL_END

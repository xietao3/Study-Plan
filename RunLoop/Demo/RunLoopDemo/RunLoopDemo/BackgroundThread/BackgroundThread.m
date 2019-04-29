//
//  BackgroundThread.m
//  RunLoopDemo
//
//  Created by xietao on 2019/4/27.
//  Copyright © 2019 com.fruitday. All rights reserved.
//

#import "BackgroundThread.h"
#import "RunLoopSource.h"
#import "RunLoopPort.h"

@implementation BackgroundThread

+ (instancetype)shareInstance {
    static BackgroundThread *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[BackgroundThread alloc] init];
    });
    return shareInstance;
}

+ (void)start {
    [BackgroundThread shareInstance].backgroundThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadEntryPoint) object:nil];
    [[BackgroundThread shareInstance].backgroundThread start];
}

+ (void)threadEntryPoint {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"BackgroundThread"];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [self addSource];
        [self addTimer];
        [self addPort];
        [runLoop run];
//        [runLoop runUntilDate:[NSDate distantFuture]];
//        [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        [BackgroundThread shareInstance].runLoop = runLoop;
    }
}

+ (void)addPort {
    RunLoopPort *runLoopPort = [[RunLoopPort alloc] init];
    [runLoopPort addPortToCurrentRunLoopWithKey:kBackgroundThreadPortKey];
}

+ (void)addTimer {
    CFRunLoopTimerRef timer = CFRunLoopTimerCreateWithHandler(CFAllocatorGetDefault(), CFAbsoluteTimeGetCurrent(), kCFAbsoluteTimeIntervalSince1904, 0, 0, ^(CFRunLoopTimerRef timer) {});
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopDefaultMode);
}

+ (void)addSource {
    RunLoopSource *source = [[RunLoopSource alloc] init];
    [source addToCurrentRunLoopWithKey:kBackgroundThreadSourceKey];

    RunLoopSource *source1 = [[RunLoopSource alloc] init];
    [source1 addToCurrentRunLoopWithKey:kBackgroundThreadSourceKey1];
}




@end

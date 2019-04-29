//
//  RunLoopSource.m
//  RunLoopDemo
//
//  Created by xietao on 2019/4/28.
//  Copyright © 2019 com.fruitday. All rights reserved.
//

#import "RunLoopSource.h"
#import "../RunLoopItemCenter/RunLoopItemCenter.h"

@implementation RunLoopSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    CFRunLoopSourceContext  context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL,
        &RunLoopSourceScheduleCallBack,
        RunLoopSourceCancelCallBack,
        RunLoopSourcePerformCallBack};
    
    self.runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
    self.runLoop = CFRunLoopGetCurrent();
    
}

- (void)addToCurrentRunLoopWithKey:(NSString *)key {
    //获取当前线程的runLoop(辅助线程)
    self.name = key;
    CFRunLoopAddSource(CFRunLoopGetCurrent(), _runLoopSource, kCFRunLoopDefaultMode);
    [RunLoopItemCenter addSource:self withKey:key];
}

+ (void)fireSourceWithKey:(NSString *)key {
    RunLoopSource *source = [RunLoopItemCenter getSourceWithKey:key];
    if (source) {
        CFRunLoopSourceSignal(source.runLoopSource);
        CFRunLoopWakeUp(source.runLoop);
    }
}

void RunLoopSourceScheduleCallBack (void *info, CFRunLoopRef rl, CFStringRef mode) {
    RunLoopSource *source = (__bridge RunLoopSource *)(info);
    NSLog(@"加入 Source：%@", source.name);
}

void RunLoopSourcePerformCallBack (void *info) {
    RunLoopSource *source = (__bridge RunLoopSource *)(info);
    NSLog(@"通知处理 Source：%@", source.name);
}

void RunLoopSourceCancelCallBack (void *info, CFRunLoopRef rl, CFStringRef mode) {
    RunLoopSource *source = (__bridge RunLoopSource *)(info);
    NSLog(@"移除 Source：%@", source.name);
    [RunLoopItemCenter removeSourceWithKey:source.name];
}

@end

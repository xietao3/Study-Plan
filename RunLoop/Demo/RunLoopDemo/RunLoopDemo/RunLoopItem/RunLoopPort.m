//
//  RunLoopPort.m
//  RunLoopDemo
//
//  Created by xietao on 2019/4/28.
//  Copyright © 2019 com.fruitday. All rights reserved.
//

#import "RunLoopPort.h"
#import "../RunLoopItemCenter/RunLoopItemCenter.h"

@interface RunLoopMainPortDelegate : NSObject <NSPortDelegate>

@end

@implementation RunLoopMainPortDelegate

- (void)handlePortMessage:(id)message {
    NSArray *components = [message valueForKeyPath:@"components"];
    NSData *data =  components[0];
    NSString *s1 = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"当前线程：%@",[NSThread currentThread]);
    NSLog(@"收到消息:%@",s1);
}

@end


@interface RunLoopPort ()<NSPortDelegate>

@property (nonatomic, strong) RunLoopMainPortDelegate *mainPortDelegate;

@end

@implementation RunLoopPort

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    _mainPort = [[NSMachPort alloc]init];
    _mainPortDelegate = [[RunLoopMainPortDelegate alloc] init];
    _mainPort.delegate = (id)_mainPortDelegate;
    [[NSRunLoop mainRunLoop] addPort:_mainPort forMode:NSDefaultRunLoopMode];
    
    _threadPort = [NSMachPort port];
    _threadPort.delegate = self;
    
}

- (void)addPortToCurrentRunLoopWithKey:(NSString *)key {
    [[NSRunLoop currentRunLoop]addPort:_threadPort forMode:NSDefaultRunLoopMode];
    [RunLoopItemCenter addPort:self withKey:key];
}


+ (void)sendPortWithMessage:(NSString *)message key:(NSString *)key {
    RunLoopPort *runLoopPort = [RunLoopItemCenter getPortWithKey:key];
    if (runLoopPort) {
        NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *components = [NSMutableArray arrayWithArray:@[data]];
        [runLoopPort.threadPort sendBeforeDate:[NSDate date] msgid:100 components:components from:runLoopPort.mainPort reserved:0];
    }
}

- (void)replyWithLocalPort:(NSPort *)localPort remotePort:(NSPort *)remotePort {
    NSMutableArray *components = [NSMutableArray arrayWithArray:@[[@"这是回复" dataUsingEncoding:NSUTF8StringEncoding]]];
    [localPort sendBeforeDate:[NSDate date] msgid:200 components:components from:remotePort reserved:0];
}

- (void)handlePortMessage:(id)message {
    NSArray *components = [message valueForKeyPath:@"components"];
    NSMachPort *localPort = [message valueForKeyPath:@"localPort"];
    NSMachPort *remotePort = [message valueForKeyPath:@"remotePort"];

    NSData *data =  components[0];
    NSString *s1 = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"当前线程：%@",[NSThread currentThread]);
    NSLog(@"收到消息:%@",s1);
    [self replyWithLocalPort:remotePort remotePort:localPort];
}

- (void)dealloc
{
    _mainPortDelegate = nil;
}

@end



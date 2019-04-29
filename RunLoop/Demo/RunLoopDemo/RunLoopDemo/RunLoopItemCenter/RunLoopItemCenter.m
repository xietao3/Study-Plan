//
//  RunLoopItemCenter.m
//  RunLoopDemo
//
//  Created by xietao on 2019/4/28.
//  Copyright © 2019 com.fruitday. All rights reserved.
//

#import "RunLoopItemCenter.h"
#import "RunLoopSource.h"
#import "RunLoopPort.h"

@interface RunLoopItemCenter ()

@property (nonatomic, strong) NSMutableDictionary *sources;
@property (nonatomic, strong) NSMutableDictionary *ports;

@end


@implementation RunLoopItemCenter

+ (instancetype)shareCenter {
    static RunLoopItemCenter *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[RunLoopItemCenter alloc] init];
    });
    return shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sources = [[NSMutableDictionary alloc] init];
        self.ports = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Source
+ (void)addSource:(RunLoopSource *)source withKey:(NSString *)key {
    [[RunLoopItemCenter shareCenter].sources setObject:source forKey:key];
}

+ (RunLoopSource *)getSourceWithKey:(NSString *)key {
    return [[RunLoopItemCenter shareCenter].sources objectForKey:key];
}

+ (BOOL)removeSourceWithKey:(NSString *)key {
    if ([[RunLoopItemCenter shareCenter].sources.allKeys containsObject:key]) {
        [[RunLoopItemCenter shareCenter].sources removeObjectForKey:key];
        return YES;
    }
    return NO;
}

#pragma mark - Port
+ (void)addPort:(RunLoopPort *)port withKey:(NSString *)key {
    [[RunLoopItemCenter shareCenter].ports setObject:port forKey:key];
}

+ (RunLoopPort *)getPortWithKey:(NSString *)key {
    return [[RunLoopItemCenter shareCenter].ports objectForKey:key];
}

+ (BOOL)removePortWithKey:(NSString *)key {
    if ([[RunLoopItemCenter shareCenter].ports.allKeys containsObject:key]) {
        [[RunLoopItemCenter shareCenter].ports removeObjectForKey:key];
        return YES;
    }
    return NO;
}


@end

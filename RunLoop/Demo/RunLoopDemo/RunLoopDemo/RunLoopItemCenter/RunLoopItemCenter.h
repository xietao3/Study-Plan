//
//  RunLoopItemCenter.h
//  RunLoopDemo
//
//  Created by xietao on 2019/4/28.
//  Copyright © 2019 com.fruitday. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RunLoopPort,RunLoopSource;

@interface RunLoopItemCenter : NSObject

+ (void)addSource:(RunLoopSource *)source withKey:(NSString *)key;

+ (RunLoopSource *)getSourceWithKey:(NSString *)key;

+ (BOOL)removeSourceWithKey:(NSString *)key;


+ (void)addPort:(RunLoopPort *)port withKey:(NSString *)key;

+ (RunLoopPort *)getPortWithKey:(NSString *)key;

+ (BOOL)removePortWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

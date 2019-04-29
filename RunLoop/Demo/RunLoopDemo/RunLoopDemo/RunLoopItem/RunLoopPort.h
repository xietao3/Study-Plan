//
//  RunLoopPort.h
//  RunLoopDemo
//
//  Created by xietao on 2019/4/28.
//  Copyright © 2019 com.fruitday. All rights reserved.
//

#import "RunLoopItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface RunLoopPort : RunLoopItem

@property (nonatomic, strong) NSMachPort *mainPort;
@property (nonatomic, strong) NSPort *threadPort;

- (void)addPortToCurrentRunLoopWithKey:(NSString *)key;

+ (void)sendPortWithMessage:(NSString *)message key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

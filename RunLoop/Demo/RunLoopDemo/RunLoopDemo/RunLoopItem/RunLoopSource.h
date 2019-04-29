//
//  RunLoopSource.h
//  RunLoopDemo
//
//  Created by xietao on 2019/4/28.
//  Copyright © 2019 com.fruitday. All rights reserved.
//

#import "RunLoopItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface RunLoopSource : RunLoopItem

@property (nonatomic) CFRunLoopSourceRef runLoopSource;

- (void)addToCurrentRunLoopWithKey:(NSString *)key;

+ (void)fireSourceWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

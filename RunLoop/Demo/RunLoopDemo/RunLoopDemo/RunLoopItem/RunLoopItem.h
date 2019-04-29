//
//  RunLoopItem.h
//  RunLoopDemo
//
//  Created by xietao on 2019/4/27.
//  Copyright © 2019 com.fruitday. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RunLoopItem : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic) CFRunLoopRef runLoop;

@end

NS_ASSUME_NONNULL_END

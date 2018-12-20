//
//  TTFakeNetworking.h
//  TestingTutorial
//
//  Created by xietao on 2018/12/8.
//  Copyright © 2018 com.fruitday. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TTFakeNetworkingInstance [TTFakeNetworking shareInstance]

NS_ASSUME_NONNULL_BEGIN

@interface TTFakeNetworking : NSObject

+ (instancetype)shareInstance;

- (void)requestWithService:(NSString *)service completionHandler:(void(^)(NSDictionary *response))completionHandler;

- (void)requestWithService:(NSString *)service parameter:(nullable NSDictionary *)parameter completionHandler:(void(^)(NSDictionary *response))completionHandler;
@end

NS_ASSUME_NONNULL_END

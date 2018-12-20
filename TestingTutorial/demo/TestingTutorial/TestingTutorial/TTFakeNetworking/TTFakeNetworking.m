//
//  TTFakeNetworking.m
//  TestingTutorial
//
//  Created by xietao on 2018/12/8.
//  Copyright © 2018 com.fruitday. All rights reserved.
//

#import "TTFakeNetworking.h"
#import "TTConstant.h"

const int maxConcurrentOperationCount = 3;
static  NSString * const operationQueueName = @"xietao3.TTFakeNetworking.queue";

@interface TTFakeNetworking()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation TTFakeNetworking

+ (instancetype)shareInstance {
    static TTFakeNetworking *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[TTFakeNetworking alloc] init];
    });
    return shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initNetworking];
    }
    return self;
}

- (void)initNetworking {
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.name = operationQueueName;
    self.operationQueue.maxConcurrentOperationCount = maxConcurrentOperationCount;
}

#pragma mark - PublicMethod
- (void)requestWithService:(NSString *)service completionHandler:(void(^)(NSDictionary *response))completionHandler {
    [self requestWithService:service parameter:nil completionHandler:completionHandler];
}

- (void)requestWithService:(NSString *)service parameter:(nullable NSDictionary *)parameter completionHandler:(void(^)(NSDictionary *response))completionHandler {
    NSLog(@"requestWithService:%@",service);
    [self routeWithService:service parameter:parameter completionHandler:completionHandler];
}

#pragma mark - PrivateMethod
- (void)routeWithService:(NSString *)service parameter:(NSDictionary *)parameter completionHandler:(void(^)(NSDictionary *response))completionHandler{
    if ([service isEqualToString:apiRecordSave]) {
        [self saveRecordWithParameter:parameter completionHandler:completionHandler];
    }else if ([service isEqualToString:apiRecordList]) {
        [self getRecordListWithCompletionHandler:completionHandler];
    }else if ([service isEqualToString:apiRecordDelete]) {
        [self deleteRecordWithParameter:parameter completionHandler:completionHandler];
    }else{
        [self asyncRequestSuccessWithDelay:1 completionHandler:completionHandler];
    }
}


- (void)saveRecordWithParameter:(nullable NSDictionary *)parameter completionHandler:(void(^)(NSDictionary *response))completionHandler{
    if (parameter && parameter.count > 0) {
        NSMutableArray *recordList = [[NSMutableArray alloc] initWithArray:[kUserDefault objectForKey:kRecordListSaveKey]];
        [recordList insertObject:parameter atIndex:0];
        [kUserDefault setValue:recordList forKey:kRecordListSaveKey];
        if (completionHandler) {
            completionHandler([self buildFakeResponseWithData:nil]);
        }
    }else{
        if (completionHandler) {
            completionHandler([self buildFailureResponseWithMsg:@"您没有输入任何数据！"]);
        }
    }
}

- (void)deleteRecordWithParameter:(nullable NSDictionary *)parameter completionHandler:(void(^)(NSDictionary *response))completionHandler{
    if (parameter && parameter.count > 0) {
        NSMutableArray *recordList = [[NSMutableArray alloc] initWithArray:[kUserDefault objectForKey:kRecordListSaveKey]];
        [recordList removeObjectAtIndex:[parameter[@"index"] intValue]];
        [kUserDefault setValue:recordList forKey:kRecordListSaveKey];
        if (completionHandler) {
            completionHandler([self buildFakeResponseWithData:nil]);
        }
    }else{
        if (completionHandler) {
            completionHandler([self buildFailureResponseWithMsg:@"您没有输入任何数据！"]);
        }
    }
}

- (void)getRecordListWithCompletionHandler:(void(^)(NSDictionary *response))completionHandler {
    NSMutableArray *recordList = [[NSMutableArray alloc] init];
    
    NSArray *saveList = [kUserDefault objectForKey:kRecordListSaveKey];
    if (saveList && saveList.count > 0) {
        [recordList addObjectsFromArray:saveList];
    }
    
    [self asyncRequestSuccessWithDelay:1.0 completionHandler:^(NSDictionary *response) {
        if (completionHandler) {
            completionHandler([self buildFakeResponseWithData:recordList]);
        }
    }];
}

- (void)asyncRequestSuccessWithDelay:(int)delay completionHandler:(void(^)(NSDictionary *response))completionHandler{
    __weak __typeof(&*self)weakSelf = self;
    NSBlockOperation *requestOperation = [NSBlockOperation blockOperationWithBlock:^{
        sleep(delay);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (completionHandler) {
                completionHandler([weakSelf buildFakeResponseWithData:nil]);
            }
        }];
    }];
    [self.operationQueue addOperation:requestOperation];
}

- (NSDictionary *)buildFakeResponseWithData:(id)data{
    NSString *code = @"200";
    NSMutableDictionary *res = [[NSMutableDictionary alloc] initWithDictionary:@{@"code":code,
                                                                                 @"data":data?:@"fake data"
                                                                                 }];
    return res;
}

- (NSDictionary *)buildFailureResponseWithMsg:(NSString *)msg{
    NSString *code = @"300";
    NSMutableDictionary *res = [[NSMutableDictionary alloc] initWithDictionary:@{@"code":code,
                                                                                 @"msg":msg?:@"request failure"
                                                                                 }];
    return res;

}
@end

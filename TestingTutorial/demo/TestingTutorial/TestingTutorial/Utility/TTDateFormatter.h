//
//  TTDateFormatter.h
//  TestingTutorial
//
//  Created by xietao on 2018/12/6.
//  Copyright © 2018 com.fruitday. All rights reserved.
//

#import <Foundation/Foundation.h>

static const double sec = 1.0;
static const double min = sec * 60;
static const double hour = min * 60;
static const double day = hour * 24;

NS_ASSUME_NONNULL_BEGIN

@interface TTDateFormatter : NSDate

+ (NSString *)stringFormatWithDate:(NSDate *)date;

+ (NSDate *)dateFormatWithString:(NSString *)dateString;

+ (BOOL)isTodayWithDateString:(NSString *)dateString;

+ (NSString *)getHowLongAgoWithTimeStamp:(NSTimeInterval)timeStamp;

+ (NSString *)getHowLongAgoWithTimeInterval:(NSTimeInterval)timeInterval;

@end

NS_ASSUME_NONNULL_END

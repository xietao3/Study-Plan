//
//  TTDateFormatter.m
//  TestingTutorial
//
//  Created by xietao on 2018/12/6.
//  Copyright © 2018 com.fruitday. All rights reserved.
//

#import "TTDateFormatter.h"

@implementation TTDateFormatter

+ (NSString *)stringFormatWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSDate *)dateFormatWithString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

+ (BOOL)isTodayWithDateString:(NSString *)dateString {
    NSDate *todayDate = [NSDate date];
    NSString *todayDateString = [self stringFormatWithDate:todayDate];
    return [dateString isEqualToString:todayDateString];
}

+ (NSString *)getHowLongAgoWithTimeStamp:(NSTimeInterval)timeStamp {
    NSDate *now = [NSDate date];
    NSTimeInterval interval = now.timeIntervalSince1970 - timeStamp;
    NSLog(@"++ %f - %f = %f",now.timeIntervalSince1970, timeStamp, interval);
    if (interval >= 3*day) {
        return [self stringFormatWithDate:[NSDate dateWithTimeIntervalSince1970:timeStamp]];
    }else{
        return [self getHowLongAgoWithTimeInterval:now.timeIntervalSince1970 - timeStamp];
    }
}

+ (NSString *)getHowLongAgoWithTimeInterval:(NSTimeInterval)timeInterval {
    int time = 0;
    NSString *unit = @"";
    if (timeInterval < min) {
        time = timeInterval / sec;
        unit = @"秒";
    }else if (timeInterval < hour) {
        time = timeInterval / min;
        unit = @"分钟";
    }else if (timeInterval < day) {
        time = timeInterval / hour;
        unit = @"小时";
    }else if (timeInterval < 3*day) {
        time = timeInterval / day;
        unit = @"天";
    }
    NSString *howLongAgo = [NSString stringWithFormat:@"%d%@前", time, unit];
    return howLongAgo;
}


@end

//
//  TTDateFormatterTests.m
//  TestingTutorialTests
//
//  Created by xietao on 2018/12/7.
//  Copyright © 2018 com.fruitday. All rights reserved.
//

#import "TTTestCase.h"
#import "TTDateFormatter.h"

@interface TTDateFormatterTests : TTTestCase

@end

@implementation TTDateFormatterTests

- (void)testDateFormatter {
    NSString *originDateString = @"2018-06-06 20:20:20";
    NSDate *date = [TTDateFormatter dateFormatWithString:originDateString];
    NSString *dateString = [TTDateFormatter stringFormatWithDate:date];
    XCTAssertEqualObjects(dateString, originDateString);
}

- (void)testDateFormatterIsToday {
    NSString *dateString = [TTDateFormatter stringFormatWithDate:[NSDate date]];
    XCTAssertTrue([TTDateFormatter isTodayWithDateString:dateString]);
    XCTAssertFalse([TTDateFormatter isTodayWithDateString:@"2000-01-01"]);
}

- (void)testDateFormatterHowLongAgo {
    NSDate *now = [NSDate date];
    NSString *secAgo = [TTDateFormatter getHowLongAgoWithTimeStamp:now.timeIntervalSince1970 - 10 * sec];
    XCTAssertEqualObjects(secAgo, @"10秒前");
    
    NSString *minAgo = [TTDateFormatter getHowLongAgoWithTimeStamp:now.timeIntervalSince1970 - 15 * min];
    XCTAssertEqualObjects(minAgo, @"15分钟前");
    
    NSString *hourAgo = [TTDateFormatter getHowLongAgoWithTimeStamp:now.timeIntervalSince1970 - 20 * hour];
    XCTAssertEqualObjects(hourAgo, @"20小时前");

    NSString *dayAgo = [TTDateFormatter getHowLongAgoWithTimeStamp:now.timeIntervalSince1970 - 25 * hour];
    XCTAssertEqualObjects(dayAgo, @"1天前");

    NSString *daysAgo = [TTDateFormatter getHowLongAgoWithTimeStamp:now.timeIntervalSince1970 - 50 * hour];
    XCTAssertEqualObjects(daysAgo, @"2天前");

    NSString *longTimeAgo = [TTDateFormatter getHowLongAgoWithTimeStamp:1544002463];
    XCTAssertEqualObjects(longTimeAgo, @"2018-12-05 17:34:23");

}

@end

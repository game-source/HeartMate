//
//  HMHeartRate.m
//  HeartMate
//
//  Created by xaoxuu on 04/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HMHeartRate.h"

@implementation HMHeartRate

+ (NSString *)primaryKey{
    return @"timestamp";
}


- (void)setTime:(NSDate *)time{
    _time = time;
    _timestamp = (NSInteger)time.timeIntervalSince1970;
    _year = time.stringValue(@"yyyy").integerValue;
    _month = time.stringValue(@"MM").integerValue;
    _day = time.stringValue(@"dd").integerValue;
    _week = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekOfYear fromDate:time];
    _hour = time.stringValue(@"HH").integerValue;
    _minute = time.stringValue(@"mm").integerValue;
    _second = time.stringValue(@"ss").integerValue;
}

@end

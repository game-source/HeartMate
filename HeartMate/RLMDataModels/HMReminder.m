//
//  HMReminder.m
//  HeartMate
//
//  Created by xaoxuu on 06/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HMReminder.h"

@implementation HMReminder

+ (NSString *)primaryKey{
    return @"identifier";
}


- (instancetype)init{
    if (self = [super init]) {
        self.identifier = [NSDate date].stringValue(@"yyyy-MM-dd HH:mm:ss Z");
        self.hour = 8;
        self.title = @"";
        self.message = @"";
    }
    return self;
}


- (NSArray<NSString *> *)descriptionForWeekday{
    NSMutableArray<NSString *> *results = [NSMutableArray array];
    if (self.weekday.count) {
        NSDate *date = [NSDate date];
        date = date.addDays(1-date.weekday);
        for (int i = 0; i < self.weekday.count; i++) {
            NSInteger weekday = self.weekday[i].integerValue;
            NSString *result = date.addDays(weekday).stringValue(@"EEEE");
            [results addObject:result];
        }
    }
    return results;
}


+ (NSString *)descriptionForWeekday:(NSInteger)weekday{
    NSDate *date = [NSDate date];
    date = date.addDays(1-date.weekday);
    NSString *result = date.addDays(weekday).stringValue(@"EEEE");
    return result;
}

@end

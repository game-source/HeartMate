//
//  LocalizedStringUtilities.m
//  HeartMate
//
//  Created by xaoxuu on 09/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "LocalizedStringUtilities.h"

@implementation LocalizedStringUtilities

/**
 日期描述（今天、昨天、2018-03-07 星期三）
 
 @param date 日期
 @return 描述
 */
+ (NSString *)stringForDate:(NSDate *)date{
    NSDate *today = [NSDate date];
    if (date.integerValue == today.integerValue) {
        return NSLocalizedString(@"Today", @"今天");
    } else if (date.addDays(1).integerValue == today.integerValue) {
        return NSLocalizedString(@"Yesterday", @"昨天");
    } else {
        return date.stringValue(@"yyyy-MM-dd EEEE");
    }
}


+ (NSString *)stringForTime:(NSDate *)time{
    NSDate *today = [NSDate date];
    if (time.integerValue == today.integerValue) {
        return [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Today", @"今天"), time.stringValue(@"HH:mm:ss")];
    } else if (time.addDays(1).integerValue == today.integerValue) {
        return [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Yesterday", @"昨天"), time.stringValue(@"HH:mm:ss")];
    } else {
        return [NSString stringWithFormat:@"%@", time.stringValue(@"MM-dd HH:mm:ss")];
    }
    
}

+ (NSString *)stringForAppVersion{
    return [NSString stringWithFormat:@"%@ (%@)", [NSBundle ax_appVersion], [NSBundle ax_appBuild]];
}

+ (NSString *)stringForCurrentWeekday{
    return [NSDate date].stringValue(@"EEEE");
}
+ (NSString *)stringForCurrentTimeInDay{
    NSString *tag;
    NSInteger hour = [NSDate date].stringValue(@"HH").integerValue;
    if (hour < 5) {
        tag = NSLocalizedString(@"Before Dawn", @"凌晨");
    } if (hour >= 5 && hour < 9) {
        tag = NSLocalizedString(@"Morning", @"早上");
    } else if (hour >= 9 && hour < 11) {
        tag = NSLocalizedString(@"Forenoon", @"上午");
    } else if (hour >= 11 && hour < 14) {
        tag = NSLocalizedString(@"Nooning", @"中午");
    } else if (hour >= 14 && hour < 19) {
        tag = NSLocalizedString(@"Afternoon", @"下午");
    } else {
        tag = NSLocalizedString(@"Evening", @"晚上");
    }
    return tag;
}

+ (NSString *)stringForGuideWithButtonDescription:(NSString *)buttonDescription actionDescription:(NSString *)actionDescription{
    return [NSString stringWithFormat:NSLocalizedString(@"Touch the %@ button to %@.", @"轻触“%@”按钮%@。"), buttonDescription.capitalizedString, actionDescription.lowercaseString];
}

@end

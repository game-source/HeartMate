//
//  LocalizedStringUtilities.h
//  HeartMate
//
//  Created by xaoxuu on 09/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalizedStringUtilities : NSObject


/**
 日期描述（今天、昨天、2018-03-07 星期三）
 
 @param date 日期
 @return 描述
 */
+ (NSString *)stringForDate:(NSDate *)date;


+ (NSString *)stringForTime:(NSDate *)time;
+ (NSString *)stringForAppVersion;


+ (NSString *)stringForCurrentWeekday;
+ (NSString *)stringForCurrentTimeInDay;

+ (NSString *)stringForGuideWithButtonDescription:(NSString *)buttonDescription actionDescription:(NSString *)actionDescription;

@end

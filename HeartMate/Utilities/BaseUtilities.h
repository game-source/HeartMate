//
//  BaseUtilities.h
//  HeartMate
//
//  Created by xaoxuu on 06/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseUtilities : NSObject

/**
 邮箱是否有效

 @param email 邮箱
 @return 是否有效
 */
+ (BOOL)validatedEmail:(NSString *)email;

/**
 中国手机号是否有效

 @param phoneNumber 手机号
 @return 是否有效
 */
+ (BOOL)validatedPhoneNumber:(NSString *)phoneNumber;

/**
 日期描述（今天、昨天、2018-03-07 星期三）
 
 @param date 日期
 @return 描述
 */
+ (NSString *)descriptionForDate:(NSDate *)date;

+ (NSString *)descriptionForAppVersion;

/**
 体脂率

 @param height 身高（米）
 @param weight 体重（千克）
 @return 体脂率
 */
+ (CGFloat)bmiWithHeight:(CGFloat)height weight:(CGFloat)weight;

+ (void)sendFeedbackEmail;

+ (NSURL *)developerURL;

@end

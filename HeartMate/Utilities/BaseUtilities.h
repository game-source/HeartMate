//
//  BaseUtilities.h
//  HeartMate
//
//  Created by xaoxuu on 06/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalizedStringUtilities.h"

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
 体脂率

 @param height 身高（米）
 @param weight 体重（千克）
 @return 体脂率
 */
+ (CGFloat)bmiWithHeight:(CGFloat)height weight:(CGFloat)weight;

+ (void)sendFeedbackEmail;

+ (NSURL *)developerURL;

@end


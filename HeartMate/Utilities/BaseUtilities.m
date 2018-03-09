//
//  BaseUtilities.m
//  HeartMate
//
//  Created by xaoxuu on 06/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BaseUtilities.h"
#import <AXKit/FeedbackKit.h>

@implementation BaseUtilities

/**
 邮箱是否有效
 
 @param email 邮箱
 @return 是否有效
 */
+ (BOOL)validatedEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


/**
 中国手机号是否有效
 
 @param phoneNumber 手机号
 @return 是否有效
 */
+ (BOOL)validatedPhoneNumber:(NSString *)phoneNumber{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}

+ (CGFloat)bmiWithHeight:(CGFloat)height weight:(CGFloat)weight{
    CGFloat bmi = weight / pow(height, 2);
    return bmi;
}

+ (void)sendFeedbackEmail{
    [[EmailManager sharedInstance] sendEmail:^(MFMailComposeViewController * _Nonnull mailCompose) {
        mailCompose.navigationBar.barStyle = UIBarStyleDefault;
        mailCompose.navigationBar.translucent = NO;
        mailCompose.navigationBar.opaque = YES;
        mailCompose.navigationBar.barTintColor = axThemeManager.color.background;
        mailCompose.navigationBar.tintColor = axThemeManager.color.theme;
        mailCompose.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:axThemeManager.color.theme, NSFontAttributeName:[UIFont fontWithName:axThemeManager.font.name size:20]};
        
        [mailCompose setToRecipients:@[@"feedback@xaoxuu.com"]];
        [mailCompose setSubject:@"Heart Mate"];
        
        
        [mailCompose setMessageBody:[NSString stringWithFormat:@"\n\n\n\napp name:%@ \napp version: %@",[NSBundle ax_appDisplayName], [LocalizedStringUtilities stringForAppVersion]] isHTML:NO];
        
    } completion:^(MFMailComposeResult result) {
        
    } fail:^(NSError * _Nonnull error) {
        
    }];
}

+ (NSURL *)developerURL{
    return [NSURL URLWithString:@"https://xaoxuu.com"];
}

@end

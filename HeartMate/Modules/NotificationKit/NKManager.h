//
//  NKManager.h
//  AXKitDemo
//
//  Created by xaoxuu on 29/11/2017.
//  Copyright © 2017 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NKManager : NSObject

/**
 检查权限
 */
+ (void)prepare;

/**
 推送本地推送

 @param identifier 推送标识符
 @param components 日期
 @param title 标题
 @param message 内容
 @param repeat 重复
 */
+ (void)pushNotificationWithIdentifier:(NSString *)identifier dateComponents:(void (^)(NSDateComponents *))components title:(nullable NSString *)title message:(NSString *)message repeat:(BOOL)repeat;

/**
 移除本地推送

 @param identifier 推送标识符
 */
+ (void)removeNotificationWithIdentifier:(NSString *)identifier;

@end
NS_ASSUME_NONNULL_END

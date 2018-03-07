//
//  LocalNotificationManager.h
//  AXKitDemo
//
//  Created by xaoxuu on 29/11/2017.
//  Copyright © 2017 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotificationManager : NSObject
+ (void)prepare;
+ (void)pushNotificationWithIdentifier:(NSString *)identifier dateComponents:(void (^)(NSDateComponents *))components title:(NSString *)title message:(NSString *)message repeat:(BOOL)repeat;
+ (void)removeNotificationWithIdentifier:(NSString *)identifier;
@end

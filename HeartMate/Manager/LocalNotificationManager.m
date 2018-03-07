//
//  LocalNotificationManager.m
//  AXKitDemo
//
//  Created by xaoxuu on 29/11/2017.
//  Copyright © 2017 Titan Studio. All rights reserved.
//

#import "LocalNotificationManager.h"
#import <UserNotifications/UserNotifications.h>



static inline void pushNotification(NSString *identifier, UNNotificationTrigger *trigger, void (^notificationContent)(UNMutableNotificationContent *content)){
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if(granted) {
                NSLog(@"授权成功");
            }
        }];
    });
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.sound = [UNNotificationSound defaultSound];
    content.title = @"title";
    content.subtitle = @"subtitle";
    content.body = @"body";
    if (notificationContent) {
        notificationContent(content);
    }
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            AXLogError(error);
        }
    }];
}

@implementation LocalNotificationManager

+ (void)prepare{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:UNAuthorizationOptionNone completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(granted) {
            NSLog(@"授权成功");
        }
    }];
    
}

+ (void)removeNotificationWithIdentifier:(NSString *)identifier{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removePendingNotificationRequestsWithIdentifiers:@[identifier]];
}


+ (void)pushNotificationWithIdentifier:(NSString *)identifier dateComponents:(void (^)(NSDateComponents *))components title:(NSString *)title message:(NSString *)message repeat:(BOOL)repeat{
    NSDateComponents *com = [[NSDateComponents alloc] init];
    if (components) {
        components(com);
    }
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:com repeats:repeat];
    pushNotification(identifier, trigger, ^(UNMutableNotificationContent *content) {
        content.title = title;
        content.body = message;
    });
}


@end

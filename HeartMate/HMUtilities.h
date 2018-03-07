//
//  HMUtilities.h
//  HeartMate
//
//  Created by xaoxuu on 06/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMUtilities : NSObject

+ (BOOL) validateEmail:(NSString *)email;

+ (BOOL) validateMobile:(NSString *)mobile;

+ (NSString *)descriptionForDate:(NSDate *)date;

@end

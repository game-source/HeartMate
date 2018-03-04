//
//  HMUser.h
//  HeartMate
//
//  Created by xaoxuu on 04/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HMData.h"

typedef NS_ENUM(NSInteger, HKGender) {
    HKGenderUnknown,
    HKGenderMale,
    HKGenderFemale,
};

@interface HMUser : HMData

#pragma mark - 基础信息

/**
 first name
 */
@property (copy, nonatomic) NSString *firstName;
/**
 last name
 */
@property (copy, nonatomic) NSString *lastName;

/**
 email
 */
@property (copy, nonatomic) NSString *email;

/**
 phone
 */
@property (copy, nonatomic) NSString *phone;

/**
 gender 请使用HKGender枚举
 HKGenderUnknown = 未知
 HKGenderMale    = 男
 HKGenderFemale  = 女
 */
@property (assign, nonatomic) NSInteger gender;

/**
 birth day
 */
@property (strong, nonatomic) NSDate *birthday;

/**
 height
 */
@property (assign, nonatomic) NSInteger height;

/**
 weight
 */
@property (assign, nonatomic) CGFloat weight;

/**
 avatar URL
 */
@property (copy, nonatomic) NSString *avatar;





@end

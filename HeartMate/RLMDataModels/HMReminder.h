//
//  HMReminder.h
//  HeartMate
//
//  Created by xaoxuu on 06/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HMData.h"

@interface HMReminder : HMData

/**
 open
 */
@property (assign, nonatomic) BOOL open;

/**
 小时
 */
@property (assign, nonatomic) NSInteger hour;

/**
 分钟
 */
@property (assign, nonatomic) NSInteger minute;

/**
 提醒标题
 */
@property (copy, nonatomic) NSString *title;

/**
 提醒内容
 */
@property (copy, nonatomic) NSString *message;

/**
 标签
 */
@property (strong, nonatomic) RLMArray<NSString *><RLMString> *tags;

/**
 周几重复
 0~6 代表：周日、周一、...、周六
 */
@property (strong, nonatomic) RLMArray<NSNumber *><RLMInt> *weekday;

/**
 identifier
 */
@property (copy, nonatomic) NSString *identifier;


- (NSArray<NSString *> *)descriptionForWeekday;

@end

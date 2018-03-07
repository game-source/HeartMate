//
//  HMHeartRate.h
//  HeartMate
//
//  Created by xaoxuu on 04/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HMData.h"


@interface HMHeartRate : HMData

/**
 此次心率测试的时间（最后一条瞬时心率的时间）
 */
@property (strong, nonatomic) NSDate *time;


/**
 平均心率
 一组测试的所有样本去除第一个值、一个最大值、一个最小值后的平均心率
 */
@property (assign, nonatomic) NSInteger heartRate;


/**
 一组测试结果集：所有瞬时心率
 */
@property (strong, nonatomic) RLMArray<NSNumber *><RLMInt> *detail;


/**
 标签
 */
@property (strong, nonatomic) RLMArray<NSString *><RLMString> *tags;

/**
 备注
 */
@property (copy, nonatomic) NSString *note;


/**
 year
 */
@property (assign, nonatomic) NSInteger timestamp;

/**
 year
 */
@property (assign, nonatomic) NSInteger year;
/**
 month
 */
@property (assign, nonatomic) NSInteger month;
/**
 day
 */
@property (assign, nonatomic) NSInteger day;
/**
 week
 */
@property (assign, nonatomic) NSInteger week;

/**
 hour
 */
@property (assign, nonatomic) NSInteger hour;
/**
 minute
 */
@property (assign, nonatomic) NSInteger minute;
/**
 second
 */
@property (assign, nonatomic) NSInteger second;



@end

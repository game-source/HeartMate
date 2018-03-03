//
//  HKCaptureSession.h
//  CardiotachMate
//
//  Created by xaoxuu on 03/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKRecord.h"

@class HKCaptureSession;

@protocol HKCaptureSessionDelegate <NSObject>

- (void)hkCaptureSession:(HKCaptureSession *)session didGetRecord:(HKRecord *)record;

@optional

- (void)hkCaptureSession:(HKCaptureSession *)session didUpdateCapturedProgress:(CGFloat)progress instantHeartRate:(NSInteger)instantHeartRate;

- (void)hkCaptureSession:(HKCaptureSession *)session didCompletedWithAverageHeartRate:(NSInteger)averageHeartRate;



- (void)hkCaptureSession:(HKCaptureSession *)session didInterruptedWithError:(NSError *)error;

@end

@interface HKCaptureSession : NSObject

/**
 delegate
 */
@property (weak, nonatomic) NSObject<HKCaptureSessionDelegate> *delegate;

/**
 期望测量时长，时长越长准确度越高，最小值为5秒，默认值为10秒
 建议调整范围在5~30秒内
 */
@property (assign, nonatomic) NSTimeInterval expectedDuration;


+ (instancetype)sharedInstance;

- (void)startRunning;

- (void)stopRunning;

@end

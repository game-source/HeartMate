//
//  HKCaptureSession.h
//  CardiotachMate
//
//  Created by xaoxuu on 03/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, HKCaptureState) {
    HKCaptureStateUnknown,
    HKCaptureStatePreparing,
    HKCaptureStateCapturing,
    HKCaptureStateError,
    HKCaptureStateCompleted,
};

@class HKCaptureSession;

@protocol HKCaptureSessionDelegate <NSObject>

@required

/**
 是否已加载完成
 
 @param session 回话
 @param finished 是否已加载完成
 @param error 错误信息
 */
- (void)hkCaptureSession:(HKCaptureSession *)session didLoadFinished:(BOOL)finished error:(nullable NSError *)error;

@optional

/**
 识别出一个有效的hue偏移值（用于绘图）

 @param session 回话
 @param timestamp 时间戳
 @param point hue偏移值（用于绘图）
 */
- (void)hkCaptureSession:(HKCaptureSession *)session timestamp:(NSTimeInterval)timestamp point:(CGFloat)point;

/**
 更新了检测进度

 @param session 回话
 @param progress 进度
 @param instantHeartRate 当前的瞬时心率
 */
- (void)hkCaptureSession:(HKCaptureSession *)session progress:(CGFloat)progress instantHeartRate:(NSInteger)instantHeartRate;

/**
 本次心率检测完成

 @param session 回话
 @param heartRate 平均心率
 @param detail 详情（所有测到的瞬时心率值）
 */
- (void)hkCaptureSession:(HKCaptureSession *)session didCompletedWithHeartRate:(NSInteger)heartRate detail:(NSArray<NSNumber *> *)detail;

/**
 心率检测状态发生了变化

 @param session 回话
 @param state 检测状态
 @param error 错误原因（如果心率检测被中断，将会有原因）
 */
- (void)hkCaptureSession:(HKCaptureSession *)session state:(HKCaptureState)state error:(NSError *)error;


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

/**
 state
 */
@property (assign, nonatomic) HKCaptureState state;

/**
 previewLayer
 */
@property (strong, nonatomic) CALayer *previewLayer;
                                                                   

+ (instancetype)sharedInstance;

- (void)prepare;

- (void)startRunning;

- (void)stopRunning;

@end
NS_ASSUME_NONNULL_END
